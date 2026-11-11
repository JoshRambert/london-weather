import Foundation

struct Day: Codable, Sendable {
    struct Forecast: Equatable, Identifiable {
        let id: String
        let dayName: String
        let highTemperature: String
        let lowTemperature: String
        let conditions: String
    }

    let datetime: String
    let datetimeEpoch: Int
    let tempMax: Double
    let tempMin: Double
    let temp: Double
    let feelsLikeMax: Double
    let feelsLikeMin: Double
    let feelsLike: Double
    let humidity: Double
    let precipitation: Double
    let precipitationProb: Double
    let snowDepth: Double
    let windGust: Double
    let windSpeed: Double
    let windDirection: Double
    let pressure: Double
    let cloudCover: Double
    let visibility: Double
    let conditions: String
    let icon: String
    let source: String
    let aqiUS: Int?
    let aqiEU: Int?
    let hours: [Hour]?

    enum CodingKeys: String, CodingKey {
        case datetime
        case datetimeEpoch
        case tempMax = "tempmax"
        case tempMin = "tempmin"
        case temp
        case feelsLikeMax = "feelslikemax"
        case feelsLikeMin = "feelslikemin"
        case feelsLike = "feelslike"
        case humidity
        case precipitation = "precip"
        case precipitationProb = "precipprob"
        case snowDepth = "snowdepth"
        case windGust = "windgust"
        case windSpeed = "windspeed"
        case windDirection = "winddir"
        case pressure
        case cloudCover = "cloudcover"
        case visibility
        case conditions
        case icon
        case source
        case aqiUS = "aqius"
        case aqiEU = "aqieur"
        case hours
    }

    func forecastDay(timeZone: TimeZone, unitGroup: WeatherUnitGroup) -> Forecast {
        Forecast(
            id: datetime,
            dayName: weekdayName(timeZone: timeZone),
            highTemperature: unitGroup.temperatureText(for: tempMax),
            lowTemperature: unitGroup.temperatureText(for: tempMin),
            conditions: conditions
        )
    }

    private func weekdayName(timeZone: TimeZone) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let dateParser = DateFormatter()
        dateParser.calendar = calendar
        dateParser.locale = Locale(identifier: "en_US_POSIX")
        dateParser.timeZone = timeZone
        dateParser.dateFormat = "yyyy-MM-dd"

        guard let date = dateParser.date(from: datetime) else {
            return datetime
        }

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.calendar = calendar
        weekdayFormatter.locale = .current
        weekdayFormatter.timeZone = timeZone
        weekdayFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        return weekdayFormatter.string(from: date)
    }
}
