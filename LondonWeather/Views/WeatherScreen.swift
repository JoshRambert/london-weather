import SwiftUI

struct WeatherScreen: View {
    let reading: WeatherReading

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var palette: SkyPalette { reading.condition.palette }

    private var heroSize: CGFloat {
        horizontalSizeClass == .regular ? 108 : 88
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [palette.top, palette.bottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    hero
                    skyline
                    metrics
                    hourlySection
                    dailySection
                    footnote
                }
                .padding(.horizontal, 22)
                .padding(.top, 8)
                .padding(.bottom, 36)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .scrollContentBackground(.hidden)
        }
        .preferredColorScheme(palette.prefersDarkStatus ? .dark : .light)
        .tint(palette.accent)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reading.place.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(3.2)
                .foregroundStyle(palette.accent)
            Text(reading.dateLine)
                .font(.title3.weight(.semibold))
                .foregroundStyle(palette.ink)
            Text("Sample · \(reading.timeLine)")
                .font(.caption.weight(.medium))
                .foregroundStyle(palette.accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(palette.accent.opacity(0.16)))
                .padding(.top, 2)
        }
        .accessibilityElement(children: .combine)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: reading.condition.symbolName)
                .font(.system(size: 34, weight: .light))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(palette.ink)
            HStack(alignment: .top, spacing: 2) {
                Text("\(reading.temperature)")
                    .font(.system(size: heroSize, weight: .light, design: .serif))
                Text("°")
                    .font(.system(size: heroSize * 0.36, weight: .light, design: .serif))
                    .padding(.top, heroSize * 0.12)
            }
            .foregroundStyle(palette.ink)
            .monospacedDigit()
            Text(reading.condition.title)
                .font(.title2.weight(.medium))
                .foregroundStyle(palette.ink)
            Text(reading.summary)
                .font(.body)
                .foregroundStyle(palette.muted)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(reading.temperature) degrees, \(reading.condition.title). \(reading.summary)")
    }

    private var skyline: some View {
        VStack(spacing: 0) {
            CitySkyline()
                .fill(palette.accent.opacity(0.8))
                .frame(height: 64)
            Rectangle()
                .fill(palette.accent)
                .frame(height: 1)
        }
        .accessibilityHidden(true)
    }

    private var metrics: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            MetricTile(label: "Feels like", value: "\(reading.feelsLike)°", palette: palette)
            MetricTile(label: "Humidity", value: "\(reading.humidity)%", palette: palette)
            MetricTile(label: "Wind", value: "\(reading.windSpeedMph) mph \(reading.windCompass)", palette: palette)
            MetricTile(label: "Cloud", value: "\(reading.cloudCover)%", palette: palette)
        }
    }

    private var hourlySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Later today")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(reading.hourly) { hour in
                        HourChip(hour: hour, palette: palette)
                    }
                }
                .padding(.vertical, 4)
            }
            .padding(12)
            .modifier(SkyCard(palette: palette))
        }
    }

    private var dailySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Seven days")
            VStack(spacing: 0) {
                ForEach(Array(reading.daily.enumerated()), id: \.element.id) { index, day in
                    if index > 0 {
                        Rectangle()
                            .fill(palette.ink.opacity(0.08))
                            .frame(height: 1)
                    }
                    DayRow(day: day, palette: palette)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .modifier(SkyCard(palette: palette))
        }
    }

    private var footnote: some View {
        Text("Figures are bundled with the app for this November morning.")
            .font(.footnote)
            .foregroundStyle(palette.muted)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption.weight(.semibold))
            .tracking(1.6)
            .foregroundStyle(palette.muted)
    }
}

private struct MetricTile: View {
    let label: String
    let value: String
    let palette: SkyPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.caption2.weight(.semibold))
                .tracking(1.1)
                .foregroundStyle(palette.muted)
            Text(value)
                .font(.title3.weight(.medium))
                .foregroundStyle(palette.ink)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .modifier(SkyCard(palette: palette))
        .accessibilityElement(children: .combine)
    }
}

private struct HourChip: View {
    let hour: HourReading
    let palette: SkyPalette

    var body: some View {
        VStack(spacing: 8) {
            Text(hour.label)
                .font(.caption)
                .foregroundStyle(palette.muted)
            Image(systemName: hour.condition.symbolName)
                .font(.body)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(palette.ink)
                .frame(height: 22)
            Text("\(hour.temperature)°")
                .font(.headline.weight(.medium))
                .foregroundStyle(palette.ink)
                .monospacedDigit()
            Text("\(hour.precipitationChance)%")
                .font(.caption2)
                .foregroundStyle(palette.accent)
                .monospacedDigit()
        }
        .frame(width: 68)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(hour.label), \(hour.condition.title), \(hour.temperature) degrees, \(hour.precipitationChance) percent chance of precipitation")
    }
}

private struct DayRow: View {
    let day: DayReading
    let palette: SkyPalette

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: day.condition.symbolName)
                .font(.body)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(palette.ink)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(day.name)
                    .font(.body.weight(.medium))
                    .foregroundStyle(palette.ink)
                Text(day.precipitationChance == 0 ? "Dry" : "\(day.precipitationChance)%")
                    .font(.caption)
                    .foregroundStyle(palette.muted)
                    .monospacedDigit()
            }
            Spacer(minLength: 8)
            Text("\(day.low)°")
                .font(.body)
                .foregroundStyle(palette.muted)
                .monospacedDigit()
                .frame(width: 40, alignment: .trailing)
            Text("\(day.high)°")
                .font(.body.weight(.semibold))
                .foregroundStyle(palette.ink)
                .monospacedDigit()
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        let chance = day.precipitationChance == 0
            ? "dry"
            : "\(day.precipitationChance) percent chance of precipitation"
        return "\(day.name), \(day.condition.title), high \(day.high) degrees, low \(day.low) degrees, \(chance)"
    }
}

private struct SkyCard: ViewModifier {
    let palette: SkyPalette

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(palette.ink.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(palette.ink.opacity(0.12), lineWidth: 1)
            )
    }
}

#Preview {
    WeatherScreen(reading: .londonSample)
}
