import SwiftUI

struct SkyPalette {
    let top: Color
    let bottom: Color
    let accent: Color
    let ink: Color
    let muted: Color
    /// Dark screens want light status-bar content.
    let prefersDarkStatus: Bool

    static let brass = Color(red: 0.769, green: 0.643, blue: 0.416)
    static let stone = Color(red: 0.957, green: 0.937, blue: 0.902)
    static let mist = Color(red: 0.773, green: 0.804, blue: 0.831)
    static let inkDark = Color(red: 0.102, green: 0.122, blue: 0.141)
    static let mutedDark = Color(red: 0.239, green: 0.275, blue: 0.314)
}

extension SkyCondition {
    var palette: SkyPalette {
        switch self {
        case .clear:
            return SkyPalette(
                top: Color(red: 0.145, green: 0.329, blue: 0.478),
                bottom: Color(red: 0.055, green: 0.102, blue: 0.141),
                accent: SkyPalette.brass,
                ink: SkyPalette.stone,
                muted: SkyPalette.mist,
                prefersDarkStatus: true
            )
        case .partlyCloudy:
            return SkyPalette(
                top: Color(red: 0.157, green: 0.275, blue: 0.373),
                bottom: Color(red: 0.067, green: 0.114, blue: 0.157),
                accent: SkyPalette.brass,
                ink: SkyPalette.stone,
                muted: SkyPalette.mist,
                prefersDarkStatus: true
            )
        case .overcast, .drizzle, .rain, .showers:
            return SkyPalette(
                top: Color(red: 0.102, green: 0.173, blue: 0.220),
                bottom: Color(red: 0.051, green: 0.086, blue: 0.110),
                accent: SkyPalette.brass,
                ink: SkyPalette.stone,
                muted: SkyPalette.mist,
                prefersDarkStatus: true
            )
        case .fog:
            return SkyPalette(
                top: Color(red: 0.620, green: 0.655, blue: 0.678),
                bottom: Color(red: 0.318, green: 0.357, blue: 0.396),
                accent: Color(red: 0.478, green: 0.345, blue: 0.165),
                ink: SkyPalette.inkDark,
                muted: SkyPalette.mutedDark,
                prefersDarkStatus: false
            )
        case .snow:
            return SkyPalette(
                top: Color(red: 0.545, green: 0.620, blue: 0.675),
                bottom: Color(red: 0.216, green: 0.275, blue: 0.329),
                accent: SkyPalette.brass,
                ink: SkyPalette.inkDark,
                muted: SkyPalette.mutedDark,
                prefersDarkStatus: false
            )
        case .thunder:
            return SkyPalette(
                top: Color(red: 0.102, green: 0.102, blue: 0.165),
                bottom: Color(red: 0.039, green: 0.039, blue: 0.071),
                accent: Color(red: 0.831, green: 0.722, blue: 0.447),
                ink: SkyPalette.stone,
                muted: SkyPalette.mist,
                prefersDarkStatus: true
            )
        }
    }
}
