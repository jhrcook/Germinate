//
//  ViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import ChameleonFramework

class LibraryViewController: UITableViewController {

    private let reusableCellIdentifier = "PlantCell"
    
    var plantsManager = PlantsArrayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPlant))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Garden"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plantsManager.savePlants()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath)
        
        // get plant and set name for cell
        let plant = plantsManager.plants[indexPath.row]
        cell.textLabel?.text = plant.name
        
        // format the date of sowing
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.detailTextLabel?.text = dateFormatter.string(from: plant.dateOfSeedSowing)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsManager.plants.count
    }
    
    @objc func addNewPlant() {
        let ac = UIAlertController(title: "New plant name", message: "Enter the name of the new plant you are sowing.", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            print("number of plants before: \(self?.plantsManager.plants.count ?? -1)")
            self?.plantsManager.newPlant(named: ac.textFields![0].text ?? "")
            print("number of plants after: \(self?.plantsManager.plants.count ?? -1)")
            self?.plantsManager.savePlants()
            self?.tableView.reloadData()
            let indexPath = IndexPath(row: (self?.plantsManager.plants.count)! - 1, section: 0)
            self?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            self?.performSegue(withIdentifier: "libraryToDetail", sender: self)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func addPlant(copiedFromPlant plant: Plant) {
        let indexPath = IndexPath(row: plantsManager.plants.count, section: 0)
        plantsManager.newPlant(named: plant.name)
        tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    func editPlantName(atIndex indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename plant", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let plant = self?.plantsManager.plants[indexPath.row],
                let text = ac.textFields![0].text,
                let manager = self?.plantsManager,
                let tableView = self?.tableView{
                plant.name = text
                manager.savePlants()
                tableView.reloadData()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationVC = segue.destination as? DetailPagingViewController, let indexPath = tableView.indexPathForSelectedRow {
//            print("segue to DetailPagingVC")
//            destinationVC.plant = plantsManager.plants[indexPath.row]
//            destinationVC.plantsManager = self.plantsManager
//        }
        
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
        let copyAction = UIContextualAction(style: .normal, title: "Copy") { [weak self] (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self?.addPlant(copiedFromPlant: self?.plantsManager.plants[indexPath.row] ?? Plant(name: ""))
            success(true)
        }
        copyAction.backgroundColor = FlatGreen()
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self?.editPlantName(atIndex: indexPath)
            success(true)
        }
        editAction.backgroundColor = FlatBlue()
        
        return UISwipeActionsConfiguration(actions: [editAction, copyAction])
    }


}

