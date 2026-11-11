import Foundation

enum WeatherFixture {
    static let data = Data(
        """
        {
          "queryCost": 1,
          "latitude": 51.5,
          "longitude": -0.12,
          "resolvedAddress": "London",
          "address": "London",
          "timezone": "Europe/London",
          "tzoffset": 0,
          "days": [
            {
              "datetime": "2026-11-11",
              "datetimeEpoch": 1762819200,
              "tempmax": 11,
              "tempmin": 6,
              "temp": 9,
              "feelslikemax": 10,
              "feelslikemin": 4,
              "feelslike": 8,
              "humidity": 80,
              "precip": 0,
              "precipprob": 10,
              "snowdepth": 0,
              "windgust": 20,
              "windspeed": 12,
              "winddir": 200,
              "pressure": 1012,
              "cloudcover": 90,
              "visibility": 10,
              "conditions": "Overcast",
              "icon": "cloudy",
              "source": "comb"
            }
          ],
          "currentConditions": {
            "datetime": "12:00:00",
            "datetimeEpoch": 1762862400,
            "temp": 9,
            "feelslike": 8,
            "humidity": 80,
            "precip": 0,
            "precipprob": 10,
            "snowdepth": 0,
            "windgust": 20,
            "windspeed": 12,
            "winddir": 200,
            "pressure": 1012,
            "visibility": 10,
            "cloudcover": 90,
            "conditions": "Overcast",
            "icon": "cloudy",
            "source": "obs"
          }
        }
        """.utf8
    )
}
