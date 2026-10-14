//
//  ColorHexTests.swift
//  HabitBuddyTests
//

import SwiftUI
import Testing
@testable import HabitBuddy

/// Colour is the one value that changes representation on its way into
/// SwiftData, so the conversion has to survive a round-trip intact.
@Suite("Colour hex conversion")
@MainActor
struct ColorHexTests {
    @Test("toHex returns the same string the colour was built from")
    func hexRoundTripsThroughColor() {
        #expect(Color(hex: "#F8CE63").toHex() == "#F8CE63")
    }

    @Test("Color(hex:) accepts a value with or without the leading #")
    func leadingHashIsOptional() {
        #expect(Color(hex: "F8CE63").toHex() == Color(hex: "#F8CE63").toHex())
    }

    @Test("Color(hex:) falls back to black when the string is not six hex digits")
    func malformedHexFallsBackToBlack() {
        #expect(Color(hex: "").toHex() == "#000000")
        #expect(Color(hex: "#FFF").toHex() == "#000000")
        #expect(Color(hex: "not a colour").toHex() == "#000000")
    }

    @Test("every accent colour offered by the picker survives a round-trip through storage")
    func accentColoursSurviveStorage() {
        let accents: [Color] = [
            .Background.yellowAccent,
            .Background.greenAccent,
            .Background.roseAccent,
        ]

        for accent in accents {
            let stored = accent.toHex()
            #expect(Color(hex: stored).toHex() == stored)
            #expect(stored != "#000000")
        }
    }
}
