import Foundation

struct CityWeather: Codable {
    let queryCost: Int
    let latitude: Double
    let longitude: Double
    let resolvedAddress: String
    let address: String
    let timezone: String
    let tzoffset: Double
    let days: [Day]
    let currentConditions: Hour
}
