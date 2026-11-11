import Foundation

struct Day: Codable {
    let datetime: String
    let datetimeEpoch: Int
    let tempmax: Double
    let tempmin: Double
    let temp: Double
    let feelslikemax: Double
    let feelslikemin: Double
    let feelslike: Double
    let humidity: Double
    let precip: Double
    let precipprob: Double
    let snowdepth: Double
    let windgust: Double
    let windspeed: Double
    let winddir: Double
    let pressure: Double
    let cloudcover: Double
    let visibility: Double
    let conditions: String
    let icon: String
    let source: String
    let aqius: Int?
    let aqieur: Int?
    let hours: [Hour]?
}
