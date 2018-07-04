//
//  HabitsTableViewController.swift
//  Active
//
//  Created by Tiago Maia Lopes on 06/06/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit
import CoreData

/// Controller in charge of displaying the list of tracked habits.
class HabitsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
    // MARK: Properties
    
    /// The Habit cell's reuse identifier.
    private let habitCellIdentifier = "Habit table view cell"
    
    /// The used persistence container. Defaults to the AppDelegate's one.
    var container = AppDelegate.persistentContainer
    
    /// The Habit storage used to fetch the tracked habits.
    var habitStorage: HabitStorage!
    
    /// The fetched results controller used to get the habits and
    /// display them with the tableView.
    private lazy var fetchedResultsController: NSFetchedResultsController<HabitMO> = {
        let fetchedController = habitStorage.makeFetchedResultsController(
            context: container.viewContext
        )
        fetchedController.delegate = self
        
        return fetchedController
    }()
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start fetching for the habits.
        // TODO: Catch the errors.
        try? fetchedResultsController.performFetch()
        
        // TODO: Check if this step will be needed.
        // Reload the tableView.
    }

    // MARK: DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: habitCellIdentifier,
            for: indexPath
        )
        
        // Get the current habit object.
        let habit = fetchedResultsController.object(at: indexPath)
        
        // Display the habit properties:
        // Its name.
        cell.textLabel?.text = habit.name
        // Its progress.
        cell.detailTextLabel?.text = "\(habit.executedCount)/\(habit.days?.count ?? 0) compleded"
        
        return cell
    }
}