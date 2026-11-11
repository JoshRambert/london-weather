import Foundation

public enum Route {
    case homeView
}

public enum HomeNavigation: Hashable {}

public enum ModalRoute: Identifiable, Equatable {
    public var id: String {
        switch self {}
    }
}

enum BottomSheetRoute: Identifiable, Equatable {
    case hourlyConditions(dayName: String, hours: [CityWeather.HourlyCondition])

    var id: String {
        switch self {
        case .hourlyConditions(let dayName, let hours):
            "hourlyConditions-\(dayName)-\(hours.count)"
        }
    }
}
