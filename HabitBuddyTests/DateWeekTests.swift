//
//  DateWeekTests.swift
//  HabitBuddyTests
//

import Foundation
import Testing
@testable import HabitBuddy

@Suite("Date week arithmetic")
struct DateWeekTests {
    private let calendar = Calendar.current

    @Test("currentWeek returns seven consecutive days beginning on the calendar's first weekday")
    func currentWeekIsSevenConsecutiveDays() {
        let week = testDate(2026, 9, 23).currentWeek

        #expect(week.count == 7)
        #expect(calendar.component(.weekday, from: week[0]) == calendar.firstWeekday)

        for (earlier, later) in zip(week, week.dropFirst()) {
            #expect(calendar.date(byAdding: .day, value: 1, to: earlier) == later)
        }
    }

    @Test("currentWeek returns days already normalised to the start of the day")
    func currentWeekReturnsStartOfDay() {
        let week = testDate(2026, 9, 23, hour: 17, minute: 42).currentWeek

        for day in week {
            #expect(day == day.startOfDay)
        }
    }

    /// Regression: the old offset arithmetic computed a day index of 0 for
    /// Sunday in Monday-first locales, returning the *following* week and
    /// excluding the very day it was asked about.
    @Test(
        "currentWeek always contains the day it was derived from, Sunday included",
        arguments: 20 ... 26
    )
    func currentWeekContainsItsOwnDay(dayOfMonth: Int) {
        let subject = testDate(2026, 9, dayOfMonth)
        let week = subject.currentWeek

        #expect(week.contains { calendar.isDate($0, inSameDayAs: subject) })
    }

    @Test("nextWeek and previousWeek sit either side of currentWeek without overlapping it")
    func neighbouringWeeksAreAdjacent() {
        let subject = testDate(2026, 9, 23)
        let week = subject.currentWeek
        let next = subject.nextWeek
        let previous = subject.previousWeek

        #expect(next.count == 7)
        #expect(previous.count == 7)
        #expect(calendar.date(byAdding: .day, value: 1, to: week.last!) == next.first)
        #expect(calendar.date(byAdding: .day, value: 1, to: previous.last!) == week.first)
        #expect(Set(week).isDisjoint(with: Set(next)))
        #expect(Set(week).isDisjoint(with: Set(previous)))
    }

    /// Regression: `selectedDays` and the storage query agree only because both
    /// speak Foundation's numbering. An ad-hoc Monday-first scheme silently
    /// shifted every habit by a day and made Sunday unreachable.
    @Test("weekday uses Foundation numbering, so Sunday is 1 and Saturday is 7")
    func weekdayUsesFoundationNumbering() {
        #expect(testDate(2026, 9, 20).weekday == 1) // Sunday
        #expect(testDate(2026, 9, 21).weekday == 2) // Monday
        #expect(testDate(2026, 9, 26).weekday == 7) // Saturday
    }

    @Test("weekday is unaffected by the time of day")
    func weekdayIgnoresTimeOfDay() {
        let justAfterMidnight = testDate(2026, 9, 20, hour: 0, minute: 1)
        let justBeforeMidnight = testDate(2026, 9, 20, hour: 23, minute: 59)

        #expect(justAfterMidnight.weekday == justBeforeMidnight.weekday)
    }

    @Test("startOfDay strips the time components")
    func startOfDayStripsTimeComponents() {
        let stripped = testDate(2026, 9, 23, hour: 17, minute: 42).startOfDay
        let components = calendar.dateComponents([.hour, .minute, .second], from: stripped)

        #expect(components.hour == 0)
        #expect(components.minute == 0)
        #expect(components.second == 0)
    }
}
