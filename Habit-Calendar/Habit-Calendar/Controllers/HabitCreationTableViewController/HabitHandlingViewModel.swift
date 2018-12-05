//
//  HabitHandlingViewModel.swift
//  Habit-Calendar
//
//  Created by Tiago Maia Lopes on 05/12/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import CoreData

/// Protocol defining the interface of any view models to be used with the HabitCreationViewController.
protocol HabitHandlingViewModel {

    // MARK: Properties

    /// Flag indicating if the habit is being edited.
    var isEditing: Bool { get }

    /// Flag indicating if the creation/edition operations are valid.
    var isValid: Bool { get }

    /// Flag indicating if the deletion operation is available.
    var canDeleteHabit: Bool { get }

    // MARK: Imperatives

    /// Deletes the habit, if deletable (The controller only shows the deletion option in case the habit
    /// is being edited).
    func deleteHabit()

    /// Saves the habit, if valid.
    func saveHabit()

    /// Returns the name of the habit to be displayed to the user.
    func getHabitName() -> String

    /// Sets the name of the habit.
    func setHabitName(_ name: String)

    /// Returns the color of the habit, if set.
    func getHabitColor() -> HabitMO.Color?

    /// Sets the color of the habit.
    func setHabitColor(_ color: HabitMO.Color)

    /// Returns the days selected for a challenge of days, if set.
    func getSelectedDays() -> [Date]?

    /// Sets the selected days for the challenge.
    func setDays(_ days: [Date])

    /// Returns the selected fire times components, if set.
    func getFireTimeComponents() -> [DateComponents]?

    /// Sets the selected fire time components.
    func setSelectedFireTimes(_ fireTimes: [DateComponents])
}

extension HabitHandlingViewModel {
    var canDeleteHabit: Bool {
        return isEditing
    }
}
