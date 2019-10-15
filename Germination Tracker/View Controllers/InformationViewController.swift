//
//  InformationViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/26/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit


/// Delegate for `InformationViewController` to handle navigations if germination or death event labels are tapped.
protocol InformationViewControllerDelegate {
    func didTapGerminationDateLabel(_ label: UILabel)
    func didTapDeathDateLabel(_ label: UILabel)
}

/*
 The view controller for the general information of a plant.
 
 It presents 5 main components within a main stack view.
 The top half is dominated by a chart showing the germinations and deaths over time.
 The bottom half has smaller cells for the date of sowing, number of seeds sown,
 number of germinations, and the number of deaths.
 Tapping each of the labels presents a way of editing the information.
 The germination and death event cells have stepper buttons for easily input information.
 */
class InformationViewController: UIViewController {
    /// Plant object to show.
    /// This object is passed to several children view controllers.
    var plant: Plant
    
    /// The object that handles the plants array.
    /// This object gets passed to several child view controllers.
    var plantsManager: PlantsArrayManager!
    
    /// A delegate for handling information changes to the plant beyond the scope of this view controller.
    var parentDelegate: InformationViewControllerDelegate?
    
    /// The main view of the controller.
    /// Everything is within this view.
    var informationView: InformationView!
    
    /// The controller for the chart.
    /// The view is passed to the `informationView`.
    var chartViewController: ChartViewController!
    
    /// Initialize the view controller with a plant object.
    init(plant: Plant) {
        self.plant = plant
        super.init(nibName: nil, bundle: nil)
    }
    
    /// There is no initialization process if there is no plant object.
    /// This initializer will cause the app to crash.
    /// - warning: Do not user this initializer.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up `chartViewController` for the plant.
        chartViewController = ChartViewController(plant: plant)
        
        // Set up the `informationView`
        informationView = InformationView(frame: view.safeAreaLayoutGuide.layoutFrame)
        view.addSubview(informationView)
        informationView.snp.makeConstraints({ make in make.edges.equalTo(view.safeAreaLayoutGuide) })
        informationView.configureViewFor(plant)
        informationView.delegate = self
        
        // Add chart view to information view
        informationView.chartContainerView.addSubview(chartViewController.view)
        chartViewController.view.snp.makeConstraints({make in make.edges.equalTo(informationView.chartContainerView)})
        
    }
    
    /// If there are any changes to the germination events, calling this function will update the relevant subviews.
    /// It updates the germination counter label and stepper and the chart.
    func updateGerminationDates() {
        informationView.set(numberOfGerminationsTo: plant.germinationDatesManager.totalCount)
        chartViewController.updateChart()
    }
    
    /// If there are any changes to the death events, calling this function will update the relevant subviews.
    /// It updates the death counter label and stepper and the chart.
    func updateDeathDates() {
        informationView.set(numberOfDeathsTo: plant.deathDatesManager.totalCount)
        chartViewController.updateChart()
    }

}

// MARK: InformationViewDelegate

extension InformationViewController: InformationViewDelegate {
    
    /// If the user taps the germination counter label to edit the events, the parent delegate is notified.
    func germinationCounterLabelWasTapped(_ label: UILabel) {
        parentDelegate?.didTapGerminationDateLabel(label)
    }
    
    
    /// If the user taps the death counter label to edit the events, the parent delegate is notified
    func deathCounterLabelWasTapped(_ label: UILabel) {
        parentDelegate?.didTapDeathDateLabel(label)
    }
    
    
    /// If the user taps on the date sown label, a model view controller is presented to allow the user to
    /// change the date.
    func dateSownLabelWasTapped(_ label: UILabel) {
        print("tapped date sown label")
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        datePickerVC.datePicker.setDate(plant.dateOfSeedSowing, animated: false)
        datePickerVC.modalPresentationStyle = .formSheet
        datePickerVC.modalTransitionStyle = .coverVertical
        present(datePickerVC, animated: true, completion: nil)
    }
    
    
    /// Response to tapping on the number of seeds label to get new value.
    /// Sends an alert with a text field to get a new value.
    func numberOfSeedsSownLabelWasTapped(_ label: UILabel) {
        let ac = UIAlertController(title: "Number of seeds sown", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { textField in
            textField.keyboardType = .numberPad
        })
        ac.addAction(UIAlertAction(title: "Enter", style: .default) { [weak self] _ in
            // Try to turn the input into an integer.
            if let numSeeds = self?.getFirstInteger(fromString: ac.textFields![0].text) {
                // Get new number of seeds.
                self?.plant.numberOfSeedsSown = numSeeds
                
                // Save information and update relevant views.
                self?.informationView.set(numberOfSeedlingsTo: numSeeds)
                self?.plantsManager.savePlants()
                self?.chartViewController.updateChart()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    /// Get the first integer from a string.
    /// Used to parse input from alert for getting number of seeds sown. Defaults to 0 if no integer is found.
    /// - parameter string: String to partse for an integer value. If there are multiple, it just returns the first.
    func getFirstInteger(fromString string: String?) -> Int {
        guard let string = string else { return 0 }
        
        let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        if stringArray.count > 0 {
            return Int(stringArray[0]) ?? 0
        } else {
            return 0
        }
    }
    
    
    /// If the germination counter stepper value changes, the data and relevant subviews are updated.
    /// If the value is decremented, the most recent event is removed.
    /// If the value is increased, the number of events for the current day is incremented.
    func germinationStepperValueDidChange(_ stepper: UIStepper) {
        let value = Int(stepper.value)
        informationView.set(numberOfGerminationsTo: value)
        if value < plant.germinationDatesManager.totalCount {
            plant.germinationDatesManager.removeMostRecentEvent()
        } else {
            plant.germinationDatesManager.addEvent(on: Date())
        }
        chartViewController.updateChart()
        plantsManager.savePlants()
    }
    
    
    /// If the death counter stepper value changes, the data and relevant subviews are updated.
    /// If the value is decremented, the most recent event is removed.
    /// If the value is increased, the number of events for the current day is incremented.
    func deathStepperValueDidChange(_ stepper: UIStepper) {
        let value = Int(stepper.value)
        informationView.set(numberOfDeathsTo: value)
        if value < plant.deathDatesManager.totalCount {
            plant.deathDatesManager.removeMostRecentEvent()
        } else {
            plant.deathDatesManager.addEvent(on: Date())
        }
        chartViewController.updateChart()
        plantsManager.savePlants()
    }
    
    
    /// The possible states of interaction for the chart: either `on` or `off`.
    enum ChartInteractionState { case on, off }
    
    
    /// Turns the chart interaction on or off.
    /// - note: This function is not currently used, though the framework is in place incase I want to
    /// add the feature in the future. Persistence of state is neccessary for this to be useful.
    func turnChartInteraction(_ state: ChartInteractionState) {
        chartViewController.germinationLineChartView.isUserInteractionEnabled = state == .on
    }
}



// MARK: DatePickerViewControllerDelegate

extension InformationViewController: DatePickerViewControllerDelegate {
    
    /// If a date is selected for the date of seed sowing, the information is stored and relevant subviews are updated.
    func dateSubmitted(_ date: Date) {
        plant.dateOfSeedSowing = date
        informationView.set(dateSownLabelTo: date)
        plantsManager.savePlants()
        chartViewController.updateChart()
    }
    
    
}
