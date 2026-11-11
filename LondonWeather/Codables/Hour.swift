import Foundation

struct Hour: Codable {
    let datetime: String
    let datetimeEpoch: Int
    let temp: Double
    let feelslike: Double
    let humidity: Double
    let precip: Double
    let precipprob: Double
    let snowdepth: Double
    let windgust: Double
    let windspeed: Double
    let winddir: Double
    let pressure: Double
    let visibility: Double
    let cloudcover: Double
    let aqius: Int?
    let aqieur: Int?
    let conditions: String
    let icon: String
    let source: String
}
