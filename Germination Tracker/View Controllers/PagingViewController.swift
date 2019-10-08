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
    
    var selectedNoteIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPageIndex = 0
        navigationItem.largeTitleDisplayMode = .never
                        
        informationViewController = InformationViewController(plant: plant)
        informationViewController.plantsManager = plantsManager
        informationViewController.parentDelegate = self
        
        notesTableViewController.plantsManager = plantsManager
        notesTableViewController.notes = plant.notes
        notesTableViewController.delegate = self
        
        viewControllers.append(informationViewController)
        viewControllers.append(notesTableViewController)
        
        dataSource = self
        delegate = self
    }
    
    
    @objc func addNewNote() {
        selectedNoteIndex = nil
        let editVC = EditNoteViewController(note: SeedNote())
        editVC.delegate = self
        push(editVC)
    }
        
    /// Push the edit note view controller with self as delegate.
    fileprivate func push(_ editNoteViewController: EditNoteViewController) {
        editNoteViewController.modalPresentationStyle = .formSheet
        editNoteViewController.modalTransitionStyle = .coverVertical
        present(editNoteViewController, animated: true, completion: nil)
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
        selectedNoteIndex = index
        let editVC = EditNoteViewController(note: plant.notes[index])
        editVC.delegate = self
        push(editVC)
    }
    
    func didDeleteNote(atIndex index: Int) {
        plant.notes.remove(at: index)
        plantsManager.savePlants()
        notesTableViewController.notes = plant.notes
    }
    
    
}


// MARK: EditNoteViewControllerDelegate

extension PagingViewController: EditNoteViewControllerDelegate {
    func noteWasEdited(_ note: SeedNote) {
        if let index = selectedNoteIndex {
            plant.replaceNote(atIndex: index, with: note)
        } else {
            plant.add(note)
        }
        plantsManager.savePlants()
        notesTableViewController.notes = plant.notes
        notesTableViewController.reloadData()
    }
}


// MARK: GerminationDatesTableViewControllerDelegate

extension PagingViewController: GerminationDatesTableViewControllerDelegate {
    
    func DatesManagerWasChanged(_ dateCounterManager: DateCounterManager) {
        informationViewController.updateGerminationDates()
        plantsManager.savePlants()
    }
    
}


// MARK: InformationViewControllerDelegate

extension PagingViewController: InformationViewControllerDelegate {
    
    func didTapGerminationDateLabel(_ label: UILabel) {
        let vc = GerminationDatesTableViewController()
        vc.datesManager = plant.germinationDatesManager
        vc.parentDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
