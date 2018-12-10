//
//  HabitHandlerViewModel.swift
//  Habit-Calendar
//
//  Created by Tiago Maia Lopes on 05/12/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import CoreData

/// Manages a habit and presents its values.
struct HabitHandlerViewModel: HabitHandlingViewModel {

    // MARK: Properties

    /// The habit being handled by this view model.
    private var habit: HabitMO?

    /// The habit storage used to create/edit/delete the habit entity.
    private let habitStorage: HabitStorage

    /// The user storage used to get the main user and associate it to the habit.
    private let userStorage: UserStorage

    /// The persistent container used to perform the operations of the habit.
    private let container: NSPersistentContainer

    /// The shortcuts manager used to add, edit,
    /// or remove a shortcut related to the habit.
    private let shortcutsManager: HabitsShortcutItemsManager

    var isEditing: Bool {
        return habit != nil
    }

    var isValid: Bool {
        return !isEditing && habitColor != nil && habitName != nil
    }

    /// The name of the habit, it can be provided by the entity, or set by the user.
    private var habitName: String?

    /// The color of the habit, provided by the entity or set by the user.
    private var habitColor: HabitMO.Color?

    /// The selected dates for the challenge of days.
    private var selectedDays: [Date]?

    /// The selected fire time components.
    private var fireTimes: [DateComponents]?

    // MARK: Initializers

    init(habit: HabitMO?,
         habitStorage: HabitStorage,
         userStorage: UserStorage,
         container: NSPersistentContainer,
         shortcutsManager: HabitsShortcutItemsManager) {
        if let habit = habit {
            self.habit = habit

            habitName = habit.name
            habitColor = habit.getColor()
            fireTimes = (habit.fireTimes as? Set<FireTimeMO>)?.map { $0.getFireTimeComponents() }
        }
        self.habitStorage = habitStorage
        self.userStorage = userStorage
        self.container = container
        self.shortcutsManager = shortcutsManager
    }

    // MARK: Imperatives

    func deleteHabit() {
        guard let habit = habit else { return }

        shortcutsManager.removeApplicationShortcut(for: habit)
        habitStorage.delete(habit, from: container.viewContext)
    }

    func saveHabit() {
        guard isValid else { return }

        container.performBackgroundTask { context in
            if self.isEditing {
                // Edit the habit.
            } else {
                // Create a new one.
                guard let user = self.userStorage.getUser(using: context) else {
                    assertionFailure("Couldn't get the user of the app.")
                    return
                }
                _ = self.habitStorage.create(
                    using: context,
                    user: user,
                    name: self.habitName!,
                    color: self.habitColor!
                )
            }

            try? context.save()
        }
    }

    func getHabitName() -> String? {
        return habitName
    }

    mutating func setHabitName(_ name: String) {
        habitName = name
    }

    func getHabitColor() -> HabitMO.Color? {
        return habitColor
    }

    mutating func setHabitColor(_ color: HabitMO.Color) {
        habitColor = color
    }

    func getSelectedDays() -> [Date]? {
        return selectedDays
    }

    mutating func setDays(_ days: [Date]) {
        selectedDays = days.sorted()
    }

    func getDaysDescriptionText() -> String {
        if let days = selectedDays, !days.isEmpty {
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    "%d day(s) selected.",
                    comment: "The label showing how many days were selected for the challenge."
                ),
                days.count
            )
        } else {
            return NSLocalizedString(
                "No days were selected.",
                comment: "Text displayed when the user didn't select any days of a new challenge of days."
            )
        }
    }

    func getFirstDateDescriptionText() -> String? {
        if let days = selectedDays, !days.isEmpty {
            return DateFormatter.shortCurrent.string(from: days.first!)
        } else {
            return nil
        }
    }

    func getLastDateDescriptionText() -> String? {
        if let days = selectedDays, !days.isEmpty {
            return DateFormatter.shortCurrent.string(from: days.last!)
        } else {
            return nil
        }
    }

    func getFireTimeComponents() -> [DateComponents]? {
        return fireTimes
    }

    mutating func setSelectedFireTimes(_ fireTimes: [DateComponents]) {
        self.fireTimes = fireTimes
    }

    func getFireTimesAmountDescriptionText() -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString(
                "%d fire time(s) selected.",
                comment: "The number of fire times selected by the user."
            ),
            fireTimes?.count ?? 0
        )
    }

    func getFireTimesDescriptionText() -> String? {
        if let fireTimes = fireTimes, !fireTimes.isEmpty {
            // TODO: This code is replicated between the protocol and this view model. Fix this.
            // Set the text for the label displaying some of the selected fire times:
            let fireTimeFormatter = DateFormatter.fireTimeFormatter
            let fireDates = fireTimes.compactMap {
                Calendar.current.date(from: $0)
                }.sorted()
            var fireTimesText = ""

            for fireDate in fireDates {
                fireTimesText += fireTimeFormatter.string(from: fireDate)

                // If the current fire time isn't the last one,
                // include a colon to separate it from the next.
                if fireDates.index(of: fireDate)! != fireDates.endIndex - 1 {
                    fireTimesText += ", "
                }
            }

            return fireTimesText
        } else {
            return nil
        }
    }
}
