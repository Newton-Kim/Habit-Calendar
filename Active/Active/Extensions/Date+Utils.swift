//
//  Date+Utils.swift
//  Active
//
//  Created by Tiago Maia Lopes on 09/06/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// Adds Utilities used by the app to the Date type.
extension Date {
    
    // MARK: Properties
    
    /// The date's components according to system's calendar.
    var components: DateComponents {
        return getCurrentCalendar().dateComponents(
            [.second, .minute, .hour, .day, .month, .year],
            from: self
        )
    }
    
    // MARK: Imperatives
    
    /// Gets the configured current calendar.
    private func getCurrentCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        return calendar
    }
    
    /// Gets a new date representing the beginning of the current date's day value.
    /// - Returns: the current date at midnight (beginning of day).
    func getBeginningOfDay() -> Date {
        return getCurrentCalendar().startOfDay(for: self)
    }
    
    /// Gets a new date representing the end of the current date's day value.
    /// - Returns: the current date at the end of the day (23:59 PM).
    func getEndOfDay() -> Date {
        // Declare the components to calculate the end of the current date's day.
        var components = DateComponents()
        components.day = 1
        // One day (24:00:00) minus one second (23:59:59). Resulting in the end
        // of the previous day.
        components.second = -1
        
        let dayAtEnd = getCurrentCalendar().date(byAdding: components, to: getBeginningOfDay())
        
        // Is there a mistake with the computation of the date?
        assert(dayAtEnd != nil, "Date+Utils -- getEndOfDay: the computation of the end of the day could'nt be performed.")
        
        return dayAtEnd!
    }
    
    /// Creates a new date by adding the asked number of days.
    /// - Parameter numberOfDays: The number of days to be added to the date.
    /// - Returns: A new date with the days added.
    func byAddingDays(_ numberOfDays: Int) -> Date? {
        return getCurrentCalendar().date(
            byAdding: .day,
            value: numberOfDays,
            to: self
        )
    }
}