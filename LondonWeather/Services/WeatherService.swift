import Foundation

enum WeatherUnitGroup: String, Sendable {
    case us
    case metric
    case uk
    case base

    var temperatureSuffix: String {
        switch self {
        case .us:
            "°F"
        case .metric, .uk:
            "°C"
        case .base:
            "K"
        }
    }
}

enum WeatherServiceError: LocalizedError, Equatable, Sendable {
    case emptyCity
    case invalidURL
    case httpStatus(code: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .emptyCity:
            "Enter a city."
        case .invalidURL:
            "The weather request could not be created."
        case .httpStatus(let code, let message):
            message.isEmpty ? "The weather request failed (\(code))." : message
        }
    }
}

protocol WeatherService: Sendable {
    var unitGroup: WeatherUnitGroup { get }
    func currentWeather(forCity city: String) async throws -> CityWeather
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

    func currentWeather(forCity city: String) async throws -> CityWeather {
        let location = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !location.isEmpty else {
            throw WeatherServiceError.emptyCity
        }
        guard let url = currentWeatherURL(city: location) else {
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
            throw WeatherServiceError.httpStatus(
                code: httpResponse.statusCode,
                message: Self.responseMessage(from: data)
            )
        }

        return try JSONDecoder().decode(CityWeather.self, from: data)
    }

    private func currentWeatherURL(city: String) -> URL? {
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

    private static func responseMessage(from data: Data) -> String {
        let text = String(decoding: data, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 300 else { return text }
        return String(text.prefix(300))
    }
}

struct InMemoryWeatherService: WeatherService {
    let unitGroup: WeatherUnitGroup
    private let currentWeatherForCity: @Sendable (String) async throws -> CityWeather

    init(
        unitGroup: WeatherUnitGroup = .metric,
        currentWeatherForCity: @escaping @Sendable (String) async throws -> CityWeather
    ) {
        self.unitGroup = unitGroup
        self.currentWeatherForCity = currentWeatherForCity
    }

    init(weather: CityWeather, unitGroup: WeatherUnitGroup = .metric) {
        self.init(unitGroup: unitGroup) { _ in
            weather
        }
    }

    init(error: WeatherServiceError, unitGroup: WeatherUnitGroup = .metric) {
        self.init(unitGroup: unitGroup) { _ in
            throw error
        }
    }

    func currentWeather(forCity city: String) async throws -> CityWeather {
        try await currentWeatherForCity(city)
    }
}
