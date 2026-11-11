import Foundation

struct CityWeather: Codable {
    let queryCost: Int
    let latitude: Double
    let longitude: Double
    let resolvedAddress: String
    let address: String
    let timezone: String
    let timezoneOffset: Double
    let days: [Day]
    let currentConditions: Hour

    enum CodingKeys: String, CodingKey {
        case queryCost
        case latitude
        case longitude
        case resolvedAddress
        case address
        case timezone
        case timezoneOffset = "tzoffset"
        case days
        case currentConditions
    }
}
