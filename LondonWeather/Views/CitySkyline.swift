import SwiftUI

/// A low silhouette: clock tower, a long roof, bridge piers, and a shard.
struct CitySkyline: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        func block(x: CGFloat, width: CGFloat, height: CGFloat) {
            path.addRect(
                CGRect(
                    x: rect.minX + rect.width * x,
                    y: rect.maxY - rect.height * height,
                    width: rect.width * width,
                    height: rect.height * height
                )
            )
        }

        block(x: 0.00, width: 0.07, height: 0.34)
        block(x: 0.078, width: 0.010, height: 0.98)
        block(x: 0.068, width: 0.030, height: 0.76)
        block(x: 0.098, width: 0.18, height: 0.42)
        block(x: 0.30, width: 0.20, height: 0.14)
        block(x: 0.328, width: 0.016, height: 0.32)
        block(x: 0.452, width: 0.016, height: 0.32)

        let peak = CGPoint(x: rect.minX + rect.width * 0.590, y: rect.maxY - rect.height * 0.98)
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.545, y: rect.maxY))
        path.addLine(to: peak)
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.645, y: rect.maxY))
        path.closeSubpath()

        block(x: 0.68, width: 0.07, height: 0.56)
        block(x: 0.76, width: 0.10, height: 0.36)
        block(x: 0.87, width: 0.055, height: 0.50)
        block(x: 0.935, width: 0.065, height: 0.28)

        return path
    }
}
