//
//  Color+Extension.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

extension Color {
    enum Font {
        static let onPale = Color(red: 157.0 / 255.0, green: 157.0 / 255.0, blue: 159.0 / 255.0)
        static let primary = Color(.label)
        static let primaryInverted = Color(.systemBackground)
        static let primaryOnLight = Color.black
    }

    enum Background {
        static let basic = Color(.systemBackground)
        static let accent = Color(.label)

        static let greenAccent = Color(red: 157.0 / 255.0, green: 195.0 / 255.0, blue: 69.0 / 255.0)
        static let roseAccent = Color(red: 252.0 / 255.0, green: 143.0 / 255.0, blue: 198.0 / 255.0)
        static let yellowAccent = Color(red: 248.0 / 255.0, green: 206.0 / 255.0, blue: 99.0 / 255.0)
        static let pale = Color(red: 246.0 / 255.0, green: 248.0 / 255.0, blue: 250.0 / 255.0)
    }

    enum TextField {
        static let border = Color(.systemGray6)
    }

    // MARK: - Hex Conversion

    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#000000"
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        return String(format: "#%02lX%02lX%02lX",
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
