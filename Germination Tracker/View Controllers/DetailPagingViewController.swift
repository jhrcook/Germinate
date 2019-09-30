//
//  DetailViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/21/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

class DetailPagingViewController: UIViewController {

    var plant: Plant!
    var plantsManager: PlantsArrayManager!
    
    var chartViewController: ChartViewController!
    
    var detailPagingView: DetailPagingView!
    var notesTableViewController: NotesTableViewController!
    
    var selectedNoteIndex: Int?
    
    var currentScrollIndex = 0 {
        didSet {
            if currentScrollIndex == 0 {
                navigationItem.rightBarButtonItem = nil
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
            }
            let titleAdditions = ["Info", "Notes"]
            title = "\(plant.name) - \(titleAdditions[currentScrollIndex])"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        currentScrollIndex = 0
        
        //let navBarHeight = (navigationController?.navigationBar.frame.height ?? 0)
        detailPagingView = DetailPagingView(frame: view.frame)
        view.addSubview(detailPagingView)
        detailPagingView.snp.makeConstraints({ make in make.edges.equalTo(view.safeAreaLayoutGuide) })
        
        // chart
        chartViewController = ChartViewController(plant: plant)
        chartViewController.drawChart(withAnimation: true)
        detailPagingView.informationView.chartContainerView.addSubview(chartViewController.view)
        chartViewController.view.snp.makeConstraints({make in
            make.edges.equalTo(detailPagingView.informationView.chartContainerView)
        })
        
        notesTableViewController = NotesTableViewController()
        setupNotesTable()
        
        setupPlantInformation()
        
        detailPagingView.scrollView.delegate = self
    }
    
    
    func setupPlantInformation() {
        
        setDateOfSowingLabel()
        
        setupNumberSeedsLabel()
        
        detailPagingView.informationView.germinationCounterLabel.text = "Num. of germinations: \(plant.numberOfGerminations)"
        detailPagingView.informationView.germinationStepper.value = Double(plant.numberOfGerminations)
        detailPagingView.informationView.germinationStepper.stepValue = 1.0
        detailPagingView.informationView.germinationStepper.minimumValue = 0
        detailPagingView.informationView.germinationStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        
        detailPagingView.informationView.deathCounterLabel.text = "Num. of deaths: \(plant.numberOfDeaths)"
        detailPagingView.informationView.deathStepper.value = Double(plant.numberOfGerminations)
        detailPagingView.informationView.deathStepper.stepValue = 1.0
        detailPagingView.informationView.deathStepper.minimumValue = 0
        detailPagingView.informationView.deathStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        
        // tep gestures
        let dateLabelTapAction = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped(_:)))
        detailPagingView.informationView.dateSownLabel.isUserInteractionEnabled = true
        detailPagingView.informationView.dateSownLabel.addGestureRecognizer(dateLabelTapAction)
        
        let numSeedsTapAction = UITapGestureRecognizer(target: self, action: #selector(numSeedsLabelTapped(_:)))
        detailPagingView.informationView.numberOfSeedsSownLabel.isUserInteractionEnabled = true
        detailPagingView.informationView.numberOfSeedsSownLabel.addGestureRecognizer(numSeedsTapAction)
    }
    
    func setDateOfSowingLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = "Date sown: \(dateFormatter.string(from: plant.dateOfSeedSowing))"
        detailPagingView.informationView.dateSownLabel.text = text
    }
    
    func setupNumberSeedsLabel() {
        detailPagingView.informationView.numberOfSeedsSownLabel.text = "Num. seeds sown: \(plant.numberOfSeedsSown)"
    }
    
    func setupNotesTable() {
        notesTableViewController.notes = plant.notes
        notesTableViewController.reloadData()
        notesTableViewController.delegate = self
        detailPagingView.notesContainerView.addSubview(notesTableViewController.view)
    }
    
}


extension DetailPagingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == detailPagingView.scrollView {
            currentScrollIndex = scrollView.contentOffset.x < 0.5 * view.frame.width ? 0 : 1
        }
    }
    
}


extension DetailPagingViewController {
    @objc func stepperChanged(_ stepper: UIStepper) {
        if stepper == detailPagingView.informationView.germinationStepper {
            detailPagingView.informationView.germinationCounterLabel.text = "Num. of germinations: \(Int(stepper.value))"
            if Int(stepper.value) < plant.numberOfGerminations {
                plant.removeGermination(atIndex: Int(stepper.value))
            } else {
                plant.addGermination(nil)
            }
            plantsManager.savePlants()
        } else if stepper == detailPagingView.informationView.deathStepper {
            detailPagingView.informationView.deathCounterLabel.text = "Num. of deaths: \(Int(stepper.value))"
            if Int(stepper.value) < plant.numberOfDeaths {
                plant.removeDeath(atIndex: Int(stepper.value))
            } else {
                plant.addDeath(nil)
            }
            plantsManager.savePlants()
        }
    }
    
    
    @objc func addNewNote() {
//        selectedNoteIndex = nil
//        let vc = EditNoteViewController(note: SeedNote())
//        vc.delegate = self
//        push(vc)
    }
    
    /// Push the edit note view controller with self as delegate.
    fileprivate func push(_ editNoteViewController: EditNoteViewController) {
//        if let navController = self.navigationController {
//            navController.pushViewController(editNoteViewController, animated: true)
//        } else {
//            let navController = UINavigationController(rootViewController: editNoteViewController)
//            self.present(navController, animated: true, completion: nil)
//        }
    }
}



extension DetailPagingViewController {
    
    @objc func dateLabelTapped(_ sender: UITapGestureRecognizer) {
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        datePickerVC.datePicker.setDate(plant.dateOfSeedSowing, animated: false)
        datePickerVC.modalPresentationStyle = .formSheet
        datePickerVC.modalTransitionStyle = .coverVertical
        present(datePickerVC, animated: true, completion: nil)
    }
    
    
    @objc func numSeedsLabelTapped(_ sender: UITapGestureRecognizer) {
        let ac = UIAlertController(title: "Number of seeds sown", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { textField in
            textField.keyboardType = .numberPad
        })
        ac.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak self] _ in
            let numSeeds = self?.getFirstInteger(fromString: ac.textFields![0].text)
            self?.plant.numberOfSeedsSown = numSeeds ?? 0
            self?.setupNumberSeedsLabel()
            self?.plantsManager.savePlants()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func getFirstInteger(fromString string: String?) -> Int {
        guard let string = string else { return 0 }
        
        let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        if stringArray.count > 0 {
            return Int(stringArray[0]) ?? 0
        } else {
            return 0
        }
    }
}


extension DetailPagingViewController: EditNoteViewControllerDelegate {
    func noteWasEdited(_ note: SeedNote) {
        if let index = selectedNoteIndex {
            plant.replaceNote(atIndex: index, with: note)
            plant.notes[index] = note
            plantsManager.savePlants()
            notesTableViewController.notes = plant.notes
            notesTableViewController.reloadData()
        } else {
            plant.add(note)
            plantsManager.savePlants()
            notesTableViewController.notes = plant.notes
            notesTableViewController.reloadData()
        }
    }
}


extension DetailPagingViewController: DatePickerViewControllerDelegate {
    func dateSubmitted(_ date: Date) {
        plant.dateOfSeedSowing = date
        setDateOfSowingLabel()
        plantsManager.savePlants()
    }
}


extension DetailPagingViewController: NotesTableViewControllerContainerDelegate {
    
    func didDeleteNote(atIndex index: Int) {
        plant.notes.remove(at: index)
        plantsManager.savePlants()
        notesTableViewController.notes = plant.notes
    }
    
    
    func didSelectNoteToEdit(atIndex index: Int) {
        selectedNoteIndex = index
        let vc = EditNoteViewController(note: SeedNote())
        vc.delegate = self
        vc.note = plant.notes[index]
        push(vc)
    }
    
}
