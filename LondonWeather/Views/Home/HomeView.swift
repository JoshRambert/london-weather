import SwiftUI

struct HomeHostingView: View {
    @State private var viewModel: HomeViewModel

    init(store: Store, weatherService: any WeatherService) {
        _viewModel = State(initialValue: HomeViewModel(store: store, weatherService: weatherService))
    }

    var body: some View {
        HomeView(viewModel: viewModel)
    }
}

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingState
            case .loaded(let resolvedAddress, let currentConditions, let forecastDays, _):
                loadedState(
                    resolvedAddress: resolvedAddress,
                    currentConditions: currentConditions,
                    forecastDays: forecastDays
                )
            case .error:
                EmptyView()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top, alignment: .trailing, spacing: 0) {
            temperatureUnitControl
        }
        .safeAreaInset(edge: .bottom, alignment: .leading, spacing: 0) {
            weatherDataAttribution
        }
        .onChange(of: viewModel.temperatureUnit) { _, _ in
            Task { await viewModel.loadCurrentWeather() }
        }
        .task {
            await viewModel.loadCurrentWeather()
        }
    }

    private var temperatureUnitControl: some View {
        Picker("Temperature unit", selection: $viewModel.temperatureUnit) {
            Text("°C").tag(WeatherUnitGroup.metric)
            Text("°F").tag(WeatherUnitGroup.us)
        }
        .pickerStyle(.segmented)
        .frame(width: 112)
        .padding(.trailing, 24)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color(.systemBackground).ignoresSafeArea(edges: .top))
    }

    private var weatherDataAttribution: some View {
        Link(
            "Weather data provided by Visual Crossing Weather",
            destination: URL(string: "https://www.visualcrossing.com")!
        )
        .font(.footnote)
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
    }

    private var loadingState: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text("Loading")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    private func loadedState(
        resolvedAddress: String,
        currentConditions: CityWeather.CurrentConditionsDetails,
        forecastDays: [Day.Forecast]
    ) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                Text(resolvedAddress)
                    .font(.system(size: 44, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                currentConditionsContainer(currentConditions)
                forecastDayList(forecastDays)
            }
        }
    }

    private func forecastDayList(_ forecastDays: [Day.Forecast]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Forecast Ahead")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)

            VStack(spacing: 0) {
                ForEach(forecastDays) { day in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(day.dayName)
                            .font(.headline)
                        Text("High \(day.highTemperature)  ·  Low \(day.lowTemperature)")
                            .font(.body)
                        Text(day.conditions)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 14)
                    .accessibilityElement(children: .combine)

                    if day.id != forecastDays.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        }
    }

    private func currentConditionsContainer(_ currentConditions: CityWeather.CurrentConditionsDetails) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            conditionLine(label: "Temperature", value: currentConditions.temperature, prominent: true)
            conditionLine(label: "Feels like", value: currentConditions.feelsLikeTemperature)
            conditionLine(label: "Conditions", value: currentConditions.conditions)
            conditionLine(label: "Wind", value: currentConditions.windSpeed)
            Button("Hourly conditions") {
                viewModel.presentHourlyConditions()
            }
            .buttonStyle(.bordered)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        }
    }

    private func conditionLine(label: String, value: String, prominent: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(prominent ? .title.weight(.semibold) : .body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let store = Store(route: .homeView)
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                store: store,
                weatherService: LiveWeatherService()
            )
        )
    }
}
