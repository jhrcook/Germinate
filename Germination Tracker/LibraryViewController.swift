//
//  ViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/20/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit

class LibraryViewController: UITableViewController {

    private let reusableCellIdentifier = "PlantCell"
    
    var plants = [Plant]()
    var plantsManager = PlantsArrayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Garden"
        
        // load plants using the plants manager
        plants = plantsManager.plants
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath)
        
        // get plant and set name for cell
        let plant = plants[indexPath.row]
        cell.textLabel?.text = plant.name
        
        // format the date of sowing
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.detailTextLabel?.text = dateFormatter.string(from: plant.dateOfSeedSowing)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }


}

