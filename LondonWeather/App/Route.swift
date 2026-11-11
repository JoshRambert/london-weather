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
