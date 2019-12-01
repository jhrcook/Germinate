//
//  PagingViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/26/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import os
import Pageboy
import AssetsPickerViewController

/**
 A paging view of general information and notes.
 
 This is the parent view controller for the detail information for a single plant.
 It has two children view controllers, one for managing the general infomation and another for the notes.
 This view controller handles most of the navigation, though some is still left to the children when the edits are narrow enough and relevant to the view controller.
 */
class PagingViewController: PageboyViewController {
    /// Plant object to show.
    /// This object is passed to several children view controllers.
    weak var plant: Plant!
    
    /// The object that handles the plants array.
    /// This object gets passed to several child view controllers.
    weak var plantsManager: PlantsArrayManager!
    
    /// The view controller for the main information page.
    var informationViewController: InformationViewController!
    
    /// The view controller for the table of notes.
    var notesTableViewController: NotesTableViewController!
    
    /// The view controller for the photos.
    var photoLibraryViewController: PhotoLibraryCollectionViewController!
    
    /// The array of view controllers for the `PageboyViewController`.
    var viewControllers = [UIViewController]()

    /// The current index of the paging view.
    /// When set, the right navigation bar button and title are updated.
    var currentPageIndex = 1 {
        didSet {
            os_log("Paging index is changing to %d", log: Log.pagingVC, type: .info, currentPageIndex)
            
            switch currentPageIndex {
            case 0:
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                    target: self,
                                                                    action: #selector(getImagesFromLibrary))
            case 2:
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                    target: self,
                                                                    action: #selector(addNewNote))
            default:
                navigationItem.rightBarButtonItem = nil
            }
            
            title = "\(plant.name) - \(["Photos", "Info", "Notes"][currentPageIndex])"
        }
    }
    
    /// The index of a selected note. This is for keeping track of which note is being edited.
    var selectedNoteIndex: Int? = nil
    
    
    override func viewDidLoad() {
        os_log("Paging view controller's view did load.", log: Log.pagingVC, type: .info)
        
        super.viewDidLoad()
        
        currentPageIndex = 1
        navigationItem.largeTitleDisplayMode = .never
        
        // Initialize the information view controller.
        informationViewController = InformationViewController(plant: plant)
        informationViewController.plantsManager = plantsManager
        informationViewController.parentDelegate = self
        
        print("info frame size: \(informationViewController.view.frame.size)")
                
        // Intialize the notes view controller.
        notesTableViewController = NotesTableViewController()
        notesTableViewController.plantsManager = plantsManager
        notesTableViewController.notes = plant.notes
        notesTableViewController.delegate = self
        
        // Initialize the photos library.
        photoLibraryViewController = PhotoLibraryCollectionViewController(plant: plant)
        
        // Provide `PageBoy` with the view controllers to page through.
        viewControllers.append(photoLibraryViewController)
        viewControllers.append(informationViewController)
        viewControllers.append(notesTableViewController)
        
        // Set `self` for `PageBoy` delegates.
        dataSource = self
        delegate = self
    }
    
    
    /// Create a new note.
    /// This presents a new view for the user to edit the new note in.
    @objc private func addNewNote() {
        os_log("User is adding a note.", log: Log.pagingVC, type: .info)
        selectedNoteIndex = nil
        let editVC = EditNoteViewController(note: SeedNote())
        editVC.delegate = self
        
        push(editVC)
    }
    
    
    /// Present a view controller to get images from the user's Photos library.
    @objc private func getImagesFromLibrary() {
        os_log("Sending view controller to get images.", log: Log.pagingVC, type: .info)
        let pickerVC = MyAssetsPickerViewController(plant: plant)
        pickerVC.myDelegate = self
        present(pickerVC, animated: true)
    }
    
        
    /// Push the edit note view controller with self as delegate.
    /// - parameter editNoteViewController: The `EditNoteViewController` to push.
    fileprivate func push(_ editNoteViewController: EditNoteViewController) {
        os_log("Pushing note editing view controller.", log: Log.pagingVC, type: .info)
        editNoteViewController.modalPresentationStyle = .formSheet
        editNoteViewController.modalTransitionStyle = .coverVertical
        present(editNoteViewController, animated: true)
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
        return .at(index: currentPageIndex)
    }
}


// MARK: PageboyViewControllerDelegate

extension PagingViewController: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        // Not used, but stub is required.
    }
    
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        // The provided `position` is a decimal value [0, 1] indicating the percent
        // progress between pages.
        let newPage = Int(round(position.x))
        if (newPage != currentPageIndex) {
            currentPageIndex = newPage
        }
    }
    
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        // Not used, but stub is required.
    }
    
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        // Not used, but stub is required.
    }
}


// MARK: NotesTableViewControllerContainerDelegate

extension PagingViewController: NotesTableViewControllerContainerDelegate {
    
    /// Presents the view for editing a notes.
    /// - parameter index: The index of the note to edit.
    func didSelectNoteToEdit(atIndex index: Int) {
        os_log("User did select note at index %d.", log: Log.pagingVC, type: .info, index)
        selectedNoteIndex = index
        let editVC = EditNoteViewController(note: plant.notes[index])
        editVC.delegate = self
        push(editVC)
    }
    
    
    /// Delete a note from the plant's list.
    /// - parameter index: The index of the note to delete.
    /// - Note: This is part of a standard `UITableView` delete sequence.
    func didDeleteNote(atIndex index: Int) {
        os_log("User did delete note at index %d.", log: Log.pagingVC, type: .info, index)
        plant.notes.remove(at: index)
        plantsManager.savePlants()
        notesTableViewController.notes = plant.notes
    }
}


// MARK: EditNoteViewControllerDelegate

extension PagingViewController: EditNoteViewControllerDelegate {
    
    /// When a note is edited, it replaces the note at the `selectedNoteIndex`.
    /// - parameter note: The edited note to keep.
    func noteWasEdited(_ note: SeedNote) {
        os_log("User edited a note.", log: Log.pagingVC, type: .info)
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

extension PagingViewController: EventDatesTableViewControllerDelegate {
    
    /// If a plant's date manager is changed, this method updated the `InformationViewController` and saves the plants array.
    /// The plant's data manager could be either the one for germination or deaths.
    func DatesManagerWasChanged(_ dateCounterManager: DateCounterManager) {
        os_log("The data of a date counter manager did change.", log: Log.pagingVC, type: .info)
        informationViewController.updateGerminationDates()
        informationViewController.updateDeathDates()
        plantsManager.savePlants()
    }
    
}


// MARK: InformationViewControllerDelegate

extension PagingViewController: InformationViewControllerDelegate {
    
    /// If the user taps on the germination label, a new view controller is presented to edit the dates and events.
    /// - parameter label: The label that was tapped (not changed here).
    func didTapGerminationDateLabel(_ label: UILabel) {
        os_log("Pushing view controller for editing germination dates.", log: Log.pagingVC, type: .info)
        let vc = EventDatesTableViewController()
        vc.datesManager = plant.germinationDatesManager
        vc.parentDelegate = self
        vc.title = "Edit germinations"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// If the user taps on the deaths label, a new view controller is presented to edit the dates and events.
    /// - parameter label: The label that was tapped (not changed here).
    func didTapDeathDateLabel(_ label: UILabel) {
        os_log("Pushing view controller for editing death dates.", log: Log.pagingVC, type: .info)
        let vc = EventDatesTableViewController()
        vc.datesManager = plant.deathDatesManager
        vc.parentDelegate = self
        vc.title = "Edit deaths"
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension PagingViewController: MyAssetsPickerViewControllerDelegate {
    
    func assetSelectDidChange(_ controller: MyAssetsPickerViewController) {
        photoLibraryViewController.plantPhotosMayHaveChanged()
    }
    
    func didFinishAssetPicking(_ controller: MyAssetsPickerViewController) {
        photoLibraryViewController.plantPhotosMayHaveChanged()
    }
}
