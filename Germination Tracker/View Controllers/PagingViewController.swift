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
    
    var informationViewController: InformationViewController!
    var notesTableViewController = NotesTableViewController()
    var viewControllers = [UIViewController]()

    var currentPageIndex = 0 {
        didSet {
            if currentPageIndex == 0 {
                navigationItem.rightBarButtonItem = nil
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
            }
            let titleAdditions = ["Info", "Notes"]
            title = "\(plant.name) - \(titleAdditions[currentPageIndex])"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(false, animated: false)
        currentPageIndex = 0
        navigationItem.largeTitleDisplayMode = .never
                        
        informationViewController = InformationViewController(plant: plant)
        informationViewController.plantsManager = plantsManager
        
        notesTableViewController.plantsManager = plantsManager
        notesTableViewController.notes = plant.notes
        notesTableViewController.delegate = self
        
        viewControllers.append(informationViewController)
        viewControllers.append(notesTableViewController)
        
        dataSource = self
        delegate = self
    }
    
    @objc func addNewNote() {
        // TODO
    }
}


// MARK: PageboyViewControllerDataSource

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


// MARK: PageboyViewControllerDelegate

extension PagingViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        currentPageIndex = Int(round(position.x))
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        
    }
    
}


// MARK: NotesTableViewControllerContainerDelegate

extension PagingViewController: NotesTableViewControllerContainerDelegate {
    func didSelectNoteToEdit(atIndex index: Int) {
        // TODO
    }
    
    func didDeleteNote(atIndex index: Int) {
        plant.notes.remove(at: index)
        notesTableViewController.notes = plant.notes
    }
    
    
}
