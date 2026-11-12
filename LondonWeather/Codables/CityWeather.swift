import Foundation

struct CityWeather: Codable, Sendable {
    struct CurrentConditionsDetails: Equatable {
        let temperature: String
        let feelsLikeTemperature: String
        let conditions: String
        let windSpeed: String
    }

    struct HourlyCondition: Equatable, Identifiable {
        let id: String
        let time: String
        let temperature: String
        let feelsLikeTemperature: String
        let conditions: String
        let windSpeed: String
    }

    let queryCost: Int?
    let latitude: Double?
    let longitude: Double?
    let resolvedAddress: String
    let address: String
    let timezone: String
    let timezoneOffset: Double?
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

    func currentConditionDetails(unitGroup: WeatherUnitGroup) -> CurrentConditionsDetails {
        CurrentConditionsDetails(
            temperature: unitGroup.temperatureText(for: currentConditions.temp),
            feelsLikeTemperature: unitGroup.temperatureText(for: currentConditions.feelsLike),
            conditions: currentConditions.conditions,
            windSpeed: unitGroup.windSpeedText(for: currentConditions.windSpeed)
        )
    }

    func hourlyConditions(unitGroup: WeatherUnitGroup) -> [HourlyCondition] {
        let hours = days.first?.hours ?? []
        return hours.map { hour in
            HourlyCondition(
                id: hour.datetime,
                time: hour.hourAndMinute,
                temperature: unitGroup.temperatureText(for: hour.temp),
                feelsLikeTemperature: unitGroup.temperatureText(for: hour.feelsLike),
                conditions: hour.conditions,
                windSpeed: unitGroup.windSpeedText(for: hour.windSpeed)
            )
        }
    }

    func forecastDays(unitGroup: WeatherUnitGroup) -> [Day.Forecast] {
        let timeZone = TimeZone(identifier: timezone) ?? .current
        return days.prefix(7).map { $0.forecastDay(timeZone: timeZone, unitGroup: unitGroup) }
    }
}
