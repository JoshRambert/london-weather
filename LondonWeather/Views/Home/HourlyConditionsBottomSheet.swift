import SwiftUI

struct HourlyConditionsBottomSheet: View {
    let dayName: String
    let hours: [CityWeather.HourlyCondition]
    let dismiss: () -> Void

    var body: some View {
        NavigationStack {
            Group {
                if hours.isEmpty {
                    Text("Hourly conditions are not available.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(hours) { hour in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(hour.time)
                                .font(.headline)
                            Text("Temperature \(hour.temperature)")
                            Text("Feels like \(hour.feelsLikeTemperature)")
                            Text(hour.conditions)
                                .foregroundStyle(.secondary)
                            Text("Wind \(hour.windSpeed)")
                        }
                        .padding(.vertical, 4)
                        .accessibilityElement(children: .combine)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(dayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: dismiss)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
