import Foundation

struct CurrentConditionsDetails: Equatable {
    let temperature: String
    let feelsLikeTemperature: String
    let conditions: String
    let windSpeed: String
}

@MainActor
@Observable
final class HomeViewModel {
    
    enum State: Equatable {
        case loading
        case loaded(resolvedAddress: String, currentConditions: CurrentConditionsDetails)
        case error
    }

    private let store: Store
    private let weatherService: any WeatherService
    private var isLoading = false

    private(set) var state: State = .loading

    init(store: Store, weatherService: any WeatherService) {
        self.store = store
        self.weatherService = weatherService
    }

    func loadCurrentWeather() async {
        guard !isLoading else { return }
        isLoading = true
        state = .loading
        defer { isLoading = false }

        do {
            let weather = try await weatherService.currentLondonWeather()
            let conditions = weather.currentConditions
            let unitGroup = weatherService.unitGroup
            state = .loaded(
                resolvedAddress: weather.resolvedAddress,
                currentConditions: CurrentConditionsDetails(
                    temperature: unitGroup.temperatureText(for: conditions.temp),
                    feelsLikeTemperature: unitGroup.temperatureText(for: conditions.feelsLike),
                    conditions: conditions.conditions,
                    windSpeed: unitGroup.windSpeedText(for: conditions.windSpeed)
                )
            )
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            state = .error
            store.presentErrorAlert(
                (error as? LocalizedError)?.errorDescription ?? "The current weather could not be loaded.",
                retryAction: { [weak self] in
                    await self?.loadCurrentWeather()
                }
            )
        }
    }
}
