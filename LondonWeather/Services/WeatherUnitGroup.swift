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

    var windSpeedUnit: String {
        switch self {
        case .us, .uk:
            "mph"
        case .metric:
            "km/h"
        case .base:
            "m/s"
        }
    }

    func temperatureText(for value: Double) -> String {
        "\(Int(value.rounded()))\(temperatureSuffix)"
    }

    func windSpeedText(for value: Double) -> String {
        "\(Int(value.rounded())) \(windSpeedUnit)"
    }
}
