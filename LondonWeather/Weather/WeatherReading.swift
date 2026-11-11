import Foundation

enum SkyCondition: Equatable {
    case clear
    case partlyCloudy
    case overcast
    case fog
    case drizzle
    case rain
    case showers
    case snow
    case thunder

    var title: String {
        switch self {
        case .clear:
            return "Clear"
        case .partlyCloudy:
            return "Partly cloudy"
        case .overcast:
            return "Overcast"
        case .fog:
            return "Fog"
        case .drizzle:
            return "Drizzle"
        case .rain:
            return "Rain"
        case .showers:
            return "Showers"
        case .snow:
            return "Snow"
        case .thunder:
            return "Thunder"
        }
    }

    var symbolName: String {
        switch self {
        case .clear:
            return "sun.max"
        case .partlyCloudy:
            return "cloud.sun"
        case .overcast:
            return "cloud"
        case .fog:
            return "cloud.fog"
        case .drizzle:
            return "cloud.drizzle"
        case .rain:
            return "cloud.rain"
        case .showers:
            return "cloud.heavyrain"
        case .snow:
            return "cloud.snow"
        case .thunder:
            return "cloud.bolt.rain"
        }
    }
}

struct HourReading: Identifiable, Equatable {
    let label: String
    let temperature: Int
    let condition: SkyCondition
    let precipitationChance: Int

    var id: String { label }
}

struct DayReading: Identifiable, Equatable {
    let name: String
    let low: Int
    let high: Int
    let condition: SkyCondition
    let precipitationChance: Int

    var id: String { name }
}

struct WeatherReading: Equatable {
    let place: String
    let dateLine: String
    let timeLine: String
    let temperature: Int
    let feelsLike: Int
    let humidity: Int
    let windSpeedMph: Int
    let windCompass: String
    let cloudCover: Int
    let condition: SkyCondition
    let summary: String
    let hourly: [HourReading]
    let daily: [DayReading]
}
