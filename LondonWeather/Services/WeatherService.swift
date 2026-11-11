import Foundation

protocol WeatherService: Sendable {
    var unitGroup: WeatherUnitGroup { get }
    func currentWeather(forCity city: String) async throws -> CityWeather
    func currentWeather(forCity city: String, unitGroup: WeatherUnitGroup) async throws -> CityWeather
    func currentLondonWeather() async throws -> CityWeather
    func currentLondonWeather(unitGroup: WeatherUnitGroup) async throws -> CityWeather
}

extension WeatherService {
    func currentWeather(forCity city: String) async throws -> CityWeather {
        try await currentWeather(forCity: city, unitGroup: unitGroup)
    }

    func currentLondonWeather() async throws -> CityWeather {
        try await currentLondonWeather(unitGroup: unitGroup)
    }

    func currentLondonWeather(unitGroup: WeatherUnitGroup) async throws -> CityWeather {
        try await currentWeather(forCity: "London", unitGroup: unitGroup)
    }
}

enum WeatherServiceError: LocalizedError, Equatable, Sendable {
    case emptyCity
    case invalidURL
    case noNetwork
    case allowanceExceeded
    case httpStatus(code: Int, message: String)
    case undecodableResponse
    case unavailable

    var errorDescription: String? {
        switch self {
        case .emptyCity:
            "Enter a city."
        case .invalidURL:
            "The weather request could not be created."
        case .noNetwork:
            "No network connection."
        case .allowanceExceeded:
            "The free weather allowance has run out."
        case .httpStatus, .unavailable:
            "The current weather could not be loaded."
        case .undecodableResponse:
            "The weather response could not be read."
        }
    }
}

struct LiveWeatherService: WeatherService {
    static let timelineBaseURL = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/")!

    private let session: URLSession
    private let baseURL: URL
    private let apiKey: String?
    let unitGroup: WeatherUnitGroup

    init(
        session: URLSession = .shared,
        baseURL: URL = LiveWeatherService.timelineBaseURL,
        apiKey: String? = nil,
        unitGroup: WeatherUnitGroup = .metric
    ) {
        self.session = session
        self.baseURL = baseURL
        let trimmedKey = apiKey?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.apiKey = (trimmedKey?.isEmpty == false) ? trimmedKey : nil
        self.unitGroup = unitGroup
    }

    func currentWeather(forCity city: String, unitGroup: WeatherUnitGroup) async throws -> CityWeather {
        do {
            return try await fetchCurrentWeather(forCity: city, unitGroup: unitGroup)
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as URLError where error.code == .cancelled {
            throw error
        } catch let error as URLError where Self.noNetworkCodes.contains(error.code) {
            throw WeatherServiceError.noNetwork
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.unavailable
        }
    }

    private func fetchCurrentWeather(forCity city: String, unitGroup: WeatherUnitGroup) async throws -> CityWeather {
        
        let location = city.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !location.isEmpty else {
            throw WeatherServiceError.emptyCity
        }
        
        guard let url = currentWeatherURL(city: location, unitGroup: unitGroup) else {
            throw WeatherServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // URLSession advertises gzip and decompresses the body. Anonymous Timeline
        // requests fail unless the client accepts gzip, so leave that header to the session.
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherServiceError.invalidURL
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 429 {
                throw WeatherServiceError.allowanceExceeded
            }
            throw WeatherServiceError.httpStatus(
                code: httpResponse.statusCode,
                message: Self.responseMessage(from: data)
            )
        }

        do {
            return try JSONDecoder().decode(CityWeather.self, from: data)
        } catch {
            throw WeatherServiceError.undecodableResponse
        }
    }

    private func currentWeatherURL(city: String, unitGroup: WeatherUnitGroup) -> URL? {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(city),
            resolvingAgainstBaseURL: false
        ) else {
            return nil
        }

        var queryItems = [
            URLQueryItem(name: "unitGroup", value: unitGroup.rawValue),
            URLQueryItem(name: "include", value: "current"),
            URLQueryItem(name: "contentType", value: "json")
        ]
        if let apiKey {
            queryItems.append(URLQueryItem(name: "key", value: apiKey))
        }
        components.queryItems = queryItems
        return components.url
    }

    private static let noNetworkCodes: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .dataNotAllowed,
        .internationalRoamingOff,
        .cannotConnectToHost,
        .cannotFindHost,
        .dnsLookupFailed
    ]

    private static func responseMessage(from data: Data) -> String {
        let text = String(decoding: data, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 300 else { return text }
        return String(text.prefix(300))
    }
}
