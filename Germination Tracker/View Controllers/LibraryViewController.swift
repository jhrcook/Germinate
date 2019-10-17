//
//  ViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import ChameleonFramework

/**
 A table view controller for all of the sowings.
 */
class LibraryViewController: UITableViewController {

    /// String to reference reusbale cells.
    private let reusableCellIdentifier = "PlantCell"
    
    /// The object that handles the plants array.
    /// This object gets passed to several child view controllers.
    var plantsManager = PlantsArrayManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar button to add a new plant.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPlant))
        
        // Set up title.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Garden"
        
        // Remove table view cell separating lines.
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Save plants and reload the table view's data every time the view will appear
        plantsManager.savePlants()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath) as! LibraryTableViewCell
        
        // Get plant and set let the cell configure itself for a plant object.
        let plant = plantsManager.plants[indexPath.row]
        cell.configureCellFor(plant)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsManager.plants.count
    }
    
    
    /// Add a new plant object.
    /// This opens a alert controller with a text field for the user to enter the new plant's name.
    /// It then saves the new plant and opens its detail view.
    @objc private func addNewPlant() {
        let ac = UIAlertController(title: "New plant name", message: "Enter the name of the new plant you are sowing.", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            // Make and save new plant.
            self?.plantsManager.newPlant(named: ac.textFields![0].text ?? "")
            self?.plantsManager.savePlants()
            
            // Reload the table view with the new plant and open its detail view.
            self?.tableView.reloadData()
            let indexPath = IndexPath(row: (self?.plantsManager.plants.count)! - 1, section: 0)
            self?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            self?.performSegue(withIdentifier: "gardenToDetail", sender: self)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    
    /// Make a new plant with the name of another plant.
    /// - parameter plant: Plant object to use as the template for the copy.
    private func addPlant(copiedFromPlant plant: Plant) {
        let indexPath = IndexPath(row: plantsManager.plants.count, section: 0)
        plantsManager.newPlant(named: plant.name)
        tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    
    /// Change the name of a plant.
    /// This function presents an alert controller with a text field for the user to enter the new name of the plant.
    /// - parameter indexPath: The index of the plant to change the name of.
    private func editPlantName(atIndex indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename plant", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let plant = self?.plantsManager.plants[indexPath.row],
                let text = ac.textFields![0].text,
                let manager = self?.plantsManager,
                let tableView = self?.tableView {
                plant.name = text
                manager.savePlants()
                tableView.reloadData()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Specific segue instructions for passing to a `PagingViewController` for a plant.
        if let destinationVC = segue.destination as? PagingViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.plant = plantsManager.plants[indexPath.row]
            destinationVC.plantsManager = self.plantsManager
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            plantsManager.plants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            plantsManager.savePlants()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // An action to copy the plant into a new `Plant` object.
        let copyAction = UIContextualAction(style: .normal, title: "Copy") { [weak self] (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self?.addPlant(copiedFromPlant: self?.plantsManager.plants[indexPath.row] ?? Plant(name: ""))
            success(true)
        }
        if #available(iOS 13, *) {
            copyAction.backgroundColor = .systemGreen
        } else {
            copyAction.backgroundColor = FlatGreen()
        }

        // An action to edit the name of a plant.
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self?.editPlantName(atIndex: indexPath)
            success(true)
        }
        if #available(iOS 13, *) {
            editAction.backgroundColor = .systemBlue
        } else {
            editAction.backgroundColor = FlatBlue()
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, copyAction])
    }


}

