import SwiftUI

enum Theme {
    static let red = Color(red: 0.89, green: 0.02, blue: 0.07)
    static let vulcanite = Color(red: 0.11, green: 0.11, blue: 0.10)
    static let engraving = Color(red: 0.93, green: 0.92, blue: 0.87)
    static let brightFrame = Color(red: 1.0, green: 0.96, blue: 0.85)
    static let chrome = LinearGradient(
        colors: [Color(white: 0.94), Color(white: 0.72), Color(white: 0.88), Color(white: 0.60)],
        startPoint: .top,
        endPoint: .bottom
    )
}
