//
//  InformationView.swift
//  Germination Tracker
//
//  Created by Joshua on 9/21/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

class InformationView: UIView {
    
    struct InfoViewPalette {
        let lightGreen = UIColor(red: 212/255, green: 255/255, blue: 214/255, alpha: 1.0)
        let green = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        let darkGreen = UIColor(red: 0/255, green: 150/255, blue: 9/255, alpha: 1.0)
    }
    let infoViewPal = InfoViewPalette()
    
    var dateSownLabel = UILabel()
    var numberOfSeedsSownLabel = UILabel()
    
    var germinationCounterContainerView = UIView()
    var germinationCounterLabel = UILabel()
    var germinationStepper = UIStepper()
    
    var deathCounterContainerView = UIView()
    var deathCounterLabel = UILabel()
    var deathStepper = UIStepper()
    
    func setupView() {
        
        // date sown label
        addSubview(dateSownLabel)
        dateSownLabel.snp.makeConstraints({ make in
            make.top.equalTo(self).inset(10)
            make.leading.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(10)
            make.height.equalTo(50)
        })
        
        // number of seeds sown label
        addSubview(numberOfSeedsSownLabel)
        numberOfSeedsSownLabel.snp.makeConstraints({ make in
            make.top.equalTo(dateSownLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(10)
            make.height.equalTo(50)
        })
        
        // germination counter
        addSubview(germinationCounterContainerView)
        germinationCounterContainerView.snp.makeConstraints({ make in
            make.top.equalTo(numberOfSeedsSownLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(10)
            make.height.equalTo(50)
        })
        
        germinationCounterContainerView.addSubview(germinationCounterLabel)
        germinationCounterContainerView.addSubview(germinationStepper)
        germinationCounterLabel.snp.makeConstraints({ make in
            make.top.equalTo(germinationCounterContainerView)
            make.leading.equalTo(germinationCounterContainerView)
            make.bottom.equalTo(germinationCounterContainerView)
        })
        germinationStepper.snp.makeConstraints({ make in
            make.centerY.equalTo(germinationCounterContainerView)
            make.leading.equalTo(germinationCounterLabel.snp.trailing)
            make.trailing.equalTo(germinationCounterContainerView).inset(8)
        })
        
        germinationCounterLabel.textColor = .white
        germinationCounterLabel.text = "Number of germinations: 0"
        germinationCounterLabel.textAlignment = .center
        germinationStepper.tintColor = .white
        
        // death counter
        addSubview(deathCounterContainerView)
        deathCounterContainerView.snp.makeConstraints({ make in
            make.top.equalTo(germinationCounterContainerView.snp.bottom).offset(10)
            make.leading.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(10)
            make.height.equalTo(50)
        })
        
        deathCounterContainerView.addSubview(deathCounterLabel)
        deathCounterContainerView.addSubview(deathStepper)
        deathCounterLabel.snp.makeConstraints({ make in
            make.top.equalTo(deathCounterContainerView)
            make.leading.equalTo(deathCounterContainerView)
            make.bottom.equalTo(deathCounterContainerView)
        })
        deathStepper.snp.makeConstraints({ make in
            make.centerY.equalTo(deathCounterContainerView)
            make.leading.equalTo(deathCounterLabel.snp.trailing)
            make.trailing.equalTo(deathCounterContainerView).inset(8)
        })
        
        addTheme(toLabel: &dateSownLabel)
        addTheme(toLabel: &numberOfSeedsSownLabel)
        addTheme(toView: &germinationCounterContainerView)
        addTheme(toView: &deathCounterContainerView)

        deathCounterLabel.textColor = .white
        deathCounterLabel.text = "Number of germinations: 0"
        deathCounterLabel.textAlignment = .center
        deathStepper.tintColor = .white
        
    }
    
    
    func setupView(withFrame newFrame: CGRect) {
        setupView()
        frame = newFrame
    }
    
    
    func addTheme(toView view: inout UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = FlatGreen()
        view.layer.borderColor = FlatGreen().cgColor
        view.layer.borderWidth = 2
    }
    
    func addTheme(toLabel label: inout UILabel) {
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = FlatGreen()
        label.layer.borderColor = FlatGreen().cgColor
        label.layer.borderWidth = 2
        label.textColor = .white
        label.textAlignment = .center
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
