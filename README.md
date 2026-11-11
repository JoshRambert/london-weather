# London Weather

A SwiftUI app for the weather over London. The first screen is a November morning in the city: the temperature, how the day feels, the hours ahead, and the week. The figures are bundled with the app, so it opens before a forecast service is connected.

## Run it

You need a Mac with Xcode 16 or later.

1. Open `LondonWeather.xcodeproj`.
2. Choose the **LondonWeather** scheme and an iPhone or iPad simulator.
3. Run.

The deployment target is iOS 17. The phone stays portrait; iPad rotates.

## Where things live

- `LondonWeather/LondonWeatherApp.swift` starts the app.
- `LondonWeather/Views/WeatherScreen.swift` is the screen.
- `LondonWeather/Weather/SampleLondonWeather.swift` holds the bundled morning. Replace `WeatherReading.londonSample` when a forecast source is connected.
- `LondonWeather/Assets.xcassets` has the icon and the brass accent colour.

The display name is London Weather. The bundle identifier is `com.londonweather.app`.
