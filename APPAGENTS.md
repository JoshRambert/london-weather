# London Weather

Agent guide for this SwiftUI app. The Xcode project is `LondonWeather.xcodeproj`, the scheme is `LondonWeather`, and the deployment target is iOS 17.

## Architecture

Keep screens, models, and data access apart.

| Folder | Role |
| --- | --- |
| `LondonWeather/Views` | SwiftUI screens. A view draws state. It does not decode JSON or open a network connection. |
| `LondonWeather/Codables` | `Codable` types for payloads and stored values. One type per file. |
| `LondonWeather/Services` | Types that load data and return codables. Views call a service. Views do not build URLs. |

`LondonWeatherApp` opens a `WindowGroup` rooted at `HomeView`.

## In this project

- `LondonWeather/Views/HomeView.swift` is the only screen.
- Codables are not added yet.
- Services are not added yet.

Add a codable or a service only when a data source is part of the task. Leave `HomeView` as the first screen.
