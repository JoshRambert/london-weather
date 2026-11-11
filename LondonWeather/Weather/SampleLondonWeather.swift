import Foundation

extension WeatherReading {
    /// Bundled stand-in for a London morning. Replace this when a forecast source is connected.
    static let londonSample: WeatherReading = {
        let observed = LondonClock.date(year: 2026, month: 11, day: 11, hour: 9, minute: 30)
        return WeatherReading(
            place: "London",
            dateLine: LondonClock.dateLine(for: observed),
            timeLine: LondonClock.timeLine(for: observed),
            temperature: 8,
            feelsLike: 6,
            humidity: 92,
            windSpeedMph: 7,
            windCompass: "NE",
            cloudCover: 100,
            condition: .drizzle,
            summary: "A fine drizzle over the city. The river is the same colour as the sky, and a coat will do more than an umbrella.",
            hourly: [
                HourReading(label: "10:00", temperature: 8, condition: .drizzle, precipitationChance: 80),
                HourReading(label: "11:00", temperature: 9, condition: .drizzle, precipitationChance: 70),
                HourReading(label: "12:00", temperature: 9, condition: .overcast, precipitationChance: 40),
                HourReading(label: "13:00", temperature: 10, condition: .overcast, precipitationChance: 30),
                HourReading(label: "14:00", temperature: 9, condition: .rain, precipitationChance: 60),
                HourReading(label: "15:00", temperature: 9, condition: .rain, precipitationChance: 75),
                HourReading(label: "16:00", temperature: 8, condition: .drizzle, precipitationChance: 50),
                HourReading(label: "17:00", temperature: 8, condition: .overcast, precipitationChance: 20),
                HourReading(label: "18:00", temperature: 7, condition: .partlyCloudy, precipitationChance: 10),
                HourReading(label: "19:00", temperature: 6, condition: .clear, precipitationChance: 0),
                HourReading(label: "20:00", temperature: 6, condition: .clear, precipitationChance: 0),
                HourReading(label: "21:00", temperature: 5, condition: .partlyCloudy, precipitationChance: 0)
            ],
            daily: [
                DayReading(name: "Wednesday", low: 8, high: 10, condition: .drizzle, precipitationChance: 90),
                DayReading(name: "Thursday", low: 5, high: 9, condition: .partlyCloudy, precipitationChance: 10),
                DayReading(name: "Friday", low: 4, high: 11, condition: .clear, precipitationChance: 0),
                DayReading(name: "Saturday", low: 7, high: 12, condition: .rain, precipitationChance: 70),
                DayReading(name: "Sunday", low: 6, high: 10, condition: .overcast, precipitationChance: 20),
                DayReading(name: "Monday", low: 3, high: 7, condition: .fog, precipitationChance: 10),
                DayReading(name: "Tuesday", low: 6, high: 11, condition: .showers, precipitationChance: 60)
            ]
        )
    }()
}

enum LondonClock {
    static let timeZone = TimeZone(identifier: "Europe/London") ?? .gmt

    static func date(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = DateComponents(
            timeZone: timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        return calendar.date(from: components) ?? Date()
    }

    static func dateLine(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = timeZone
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: date)
    }

    static func timeLine(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
