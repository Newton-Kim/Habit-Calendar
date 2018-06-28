//
//  HabitFactory.swift
//  ActiveTests
//
//  Created by Tiago Maia Lopes on 23/06/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation
import CoreData
@testable import Active

/// Factory in charge of generating Day (entity) dummies.
struct HabitFactory: DummyFactory {
    
    // MARK: Types
    
    // This factory generates entities of the Habit class.
    typealias Entity = Habit
    
    // MARK: Properties
    
    var container: NSPersistentContainer
    
    /// The maximum number of days contained within the generated dummy.
    private let maxNumberOfDays = 61
    
    /// A collection of dummy habit names.
    private let names = [
        "Play the guitar",
        "Play the piano",
        "Go jogging",
        "Play chess",
        "Read",
        "Go swimming",
        "Workout",
        "Write",
        "Study math",
        "Program",
        "Learn to dance"
    ]
    
    // MARK: Imperatives
    
    /// Generates and returns a Habit dummy entity.
    /// - Note: The dummy is related to other HabitDay
    ///         and Notification dummies.
    /// - Returns: The Habit entity as an NSManagedObject.
    func makeDummy() -> Habit {
        // Declare the habit entity.
        let habit = Habit(context: container.viewContext)
        
        // Associate it's properties (id, created, name, color).
        habit.id = UUID().uuidString
        habit.created = Date()
        habit.name = names[Int.random(0..<names.count)]
        // TODO: Make the color be a random value.
        // Write the enum first.
        habit.color = "Green"
        
        // Declare a NotificationFactory's instance.
        let notificationFactory = NotificationFactory(container: container)
        
        // Declare a HabitDayFactory's instance.
        let habitDayFactory = HabitDayFactory(container: container)
        
        // Associate it's relationships:
        let randomRange = 0..<Int.random(2..<maxNumberOfDays)
        for dayIndex in randomRange {
            // Declare the current day's date.
            if let dayDate = Date().byAddingDays(dayIndex) {
                
                // Declare the current habit.
                let dummyHabitDay = habitDayFactory.makeDummy()
                // Declare the current notification.
                let dummyNotification = notificationFactory.makeDummy()
                
                // Associate the date to the day and notification entities.
                dummyHabitDay.day?.date = dayDate
                dummyNotification.fireDate = dayDate
                
                // Associate the notification and day to the habit entity.
                habit.addToNotifications(
                    dummyNotification
                )
                habit.addToDays(
                    dummyHabitDay
                )
            }
        }
        
        return habit
    }
}
