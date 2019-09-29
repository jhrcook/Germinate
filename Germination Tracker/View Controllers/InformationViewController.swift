//
//  InformationViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/26/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class InformationViewController: UIViewController {

    var plant: Plant
    var plantsManager: PlantsArrayManager!
    
    var informationView: InformationView!
    var chartViewController: ChartViewController!
    
    init(plant: Plant) {
        self.plant = plant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set up chartViewController
        chartViewController = ChartViewController(plant: plant)
        
        // set up the informationView
        informationView = InformationView(frame: view.safeAreaLayoutGuide.layoutFrame)
        view.addSubview(informationView)
        informationView.snp.makeConstraints({ make in make.edges.equalTo(view.safeAreaLayoutGuide) })
        informationView.configureViewFor(plant)
        informationView.delegate = self
        
        // add chart view to information view
        informationView.chartContainerView.addSubview(chartViewController.view)
        chartViewController.view.snp.makeConstraints({make in make.edges.equalTo(informationView.chartContainerView)})
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: InformationViewDelegate

extension InformationViewController: InformationViewDelegate {
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
    ///
    /// Sends an alert with a text field to get a new value.
    func numberOfSeedsSownLabelWasTapped(_ label: UILabel) {
        let ac = UIAlertController(title: "Number of seeds sown", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { textField in
            textField.keyboardType = .numberPad
        })
        ac.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak self] _ in
            if let numSeeds = self?.getFirstInteger(fromString: ac.textFields![0].text) {
                self?.plant.numberOfSeedsSown = numSeeds
                self?.informationView.set(numberOfSeedlingsTo: numSeeds)
                self?.plantsManager.savePlants()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    /// Get the first integer from a string.
    ///
    /// Used to parse input from alert for getting number of seeds sown. Defaults to 0 if no integer is found.
    func getFirstInteger(fromString string: String?) -> Int {
        guard let string = string else { return 0 }
        
        let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        if stringArray.count > 0 {
            return Int(stringArray[0]) ?? 0
        } else {
            return 0
        }
    }
    
    func germinationStepperValueDidChange(_ stepper: UIStepper) {
        let value = Int(stepper.value)
        informationView.set(numberOfGerminationsTo: value)
        if value < plant.numberOfGerminations {
            plant.removeGermination(atIndex: value)
        } else {
            plant.addGermination(nil)
        }
        chartViewController.setGerminationLineChart()
        plantsManager.savePlants()
    }
    
    func deathStepperValueDidChange(_ stepper: UIStepper) {
        let value = Int(stepper.value)
        informationView.set(numberOfDeathsTo: value)
        if value < plant.numberOfDeaths {
            plant.removeDeath(atIndex: value)
        } else {
            plant.addDeath(nil)
        }
        plantsManager.savePlants()
    }
    
    
}



// MARK: DatePickerViewControllerDelegate

extension InformationViewController: DatePickerViewControllerDelegate {
    func dateSubmitted(_ date: Date) {
        plant.dateOfSeedSowing = date
        informationView.set(dateSownLabelTo: date)
        plantsManager.savePlants()
    }
    
    
}
