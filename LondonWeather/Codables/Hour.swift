import Foundation

struct Hour: Codable {
    let datetime: String
    let datetimeEpoch: Int
    let temp: Double
    let feelsLike: Double
    let humidity: Double
    let precip: Double
    let precipProb: Double
    let snowDepth: Double
    let windGust: Double
    let windSpeed: Double
    let windDir: Double
    let pressure: Double
    let visibility: Double
    let cloudCover: Double
    let aqiUS: Int?
    let aqiEU: Int?
    let conditions: String
    let icon: String
    let source: String

    enum CodingKeys: String, CodingKey {
        case datetime
        case datetimeEpoch
        case temp
        case feelsLike = "feelslike"
        case humidity
        case precip
        case precipProb = "precipprob"
        case snowDepth = "snowdepth"
        case windGust = "windgust"
        case windSpeed = "windspeed"
        case windDir = "winddir"
        case pressure
        case visibility
        case cloudCover = "cloudcover"
        case aqiUS = "aqius"
        case aqiEU = "aqieur"
        case conditions
        case icon
        case source
    }
}
