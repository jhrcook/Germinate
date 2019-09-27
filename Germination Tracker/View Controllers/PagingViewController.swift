//
//  PagingViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/26/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import Pageboy
import ChameleonFramework

class PagingViewController: PageboyViewController {
    
    weak var plant: Plant!
    weak var plantsManager: PlantsArrayManager!
    
    var informationViewController = InformationViewController()
    var notesTableViewController = NotesTableViewController()
    var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationViewController.plant = plant
        informationViewController.plantsManager = plantsManager
        
        notesTableViewController.plantsManager = plantsManager
        notesTableViewController.notes = plant.notes
        
        viewControllers.append(informationViewController)
        viewControllers.append(notesTableViewController)
        
        dataSource = self
    }

}


/// MARK: PageboyViewControllerDataSource

extension PagingViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }
    
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
