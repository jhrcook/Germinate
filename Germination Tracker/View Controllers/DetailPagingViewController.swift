//
//  DetailViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/21/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class DetailPagingViewController: UIViewController {

    var plant: Plant!
    var plantsManager: PlantsArrayManager!
    
    @IBOutlet var detailPagingView: DetailPagingView!
    
    var currentScrollIndex = 0 {
        didSet {
            let titleAdditions = ["Info", "Notes"]
            title = "\(plant.name) - \(titleAdditions[currentScrollIndex])"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        currentScrollIndex = 0
        
        detailPagingView.navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
        detailPagingView.setupView()
        setupPlantInformation()
        
        detailPagingView.scrollView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupPlantInformation() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = "Date sown: \(dateFormatter.string(from: plant.dateOfSeedSowing))"
        detailPagingView.informationView.dateSownLabel.text = text
        
        detailPagingView.informationView.numberOfSeedsSownLabel.text = "Num. seeds sown: \(plant.numberOfSeedsSown)"
        
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
    }
    
}


extension DetailPagingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentScrollIndex = scrollView.contentOffset.x < 0.5 * 414.0 ? 0 : 1
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
}
