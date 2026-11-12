# London Weather

A SwiftUI app. The home screen loads London’s current conditions, then a seven-day list that starts with today. Each day shows the weekday name, the high and low temperature, and the conditions text. Tapping **Hourly conditions** opens a bottom sheet of that day’s hours. A control at the top right switches between Celsius and Fahrenheit.

Agent instructions are in `AGENTS.md`.

## Build and run

This project was built with **Xcode 27.2** (build 27B52).

Open `LondonWeather.xcodeproj`, choose the **LondonWeather** scheme, and run it on an iPhone or iPad simulator. The deployment target is iOS 17.

Weather service tests are in the **LondonWeatherTests** target on the same scheme. They use a stubbed session and do not call the network.

## How the code is organised

The app follows a custom **DMVVM-C** layout: Dual-Write Models, MVVM, and one coordinator. Domain types own their helpers. Screens talk only to a view model. One `Store` owns navigation and the error alert. There is no repository or use-case layer.

That shape is intentional even though this app does not persist weather yet. The same places can later hold local storage and a remote write without introducing a second pattern.

| Area | Role |
| --- | --- |
| `App/Store.swift`, `Route.swift` | Navigation state: route, modal, bottom sheet, and the error alert. |
| `App/RootView.swift` | Switches the route, presents the alert and the hourly bottom sheet. |
| `App/AppDependencies.swift` | The long-lived `WeatherService`, created once at launch. |
| `Views/Home/HomeHostingView` | Owns `HomeViewModel` in `@State` so a `RootView` refresh does not throw the forecast away. |
| `Views/Home/HomeView` | Layout only. |
| `Views/Home/HomeViewModel` | Loads London, tracks loading / loaded / error, and asks the `Store` to present errors and the hourly sheet. |
| `Codables/` | `CityWeather`, `Day`, and `Hour`. They decode the API payload and build the current-conditions and seven-day display values. |
| `Services/` | `WeatherService` and `LiveWeatherService` call Visual Crossing. `WeatherUnitGroup` formats Celsius and Fahrenheit. |
| `LondonWeatherTests/` | Service tests and the `WeatherFixture` mock. |

`Store` and `AppDependencies` use `@Observable` and `.environment`, not `ObservableObject`. A view refreshes only when a property it read changes, so an alert or a sheet does not redraw the whole app.

## With more time

In this order:

1. Accessibility: labels, hints, Dynamic Type, and a pass over the hourly sheet and the seven-day list.
2. Local storage so the last forecast can be shown offline.
3. Search for other cities.

## If this were going to the App Store

Clean up the UI and UX. Add custom icons, animations, and presentations.

## AI assistants

Built with my own agentic workflow.

## Time

About 2–3 hours for the MVP and the additional features.
