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
    
    var dateSownContainerView = UIView()
    var dateSownLabel = UILabel()
    
    var numberOfSeedsSownContainerView = UIView()
    var numberOfSeedsSownLabel = UILabel()
    
    var germinationCounterContainerView = UIStackView()
    var germinationCounterLabel = UILabel()
    var germinationStepper = UIStepper()
    var germinationStepperBackgroundView = UIView()
    
    var deathCounterLabel = UILabel()
    var deathStepper = UIStepper()
    var deathCounterContainerView = UIStackView()
    var deathStepperBackgroundView = UIView()
    
    var chartContainerView = UIStackView()
    
    var mainStackView = UIStackView()
    
    var halfViewFrameHeight: CGFloat = 0
    var heightOfTopViews: CGFloat = 0
    var sideInset: CGFloat = 10
    var verticalSeparation: CGFloat = 5
    
    var cornerRadius: CGFloat = 8
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the main stack view.
    func setupStackView() {
        
        halfViewFrameHeight = frame.height / 2.0
        heightOfTopViews = halfViewFrameHeight / 4.0
        
        addSubview(germinationStepperBackgroundView)
        addSubview(deathStepperBackgroundView)
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({ make in make.edges.equalTo(safeAreaLayoutGuide) })
        
        mainStackView.addArrangedSubview(dateSownContainerView)
        mainStackView.addArrangedSubview(numberOfSeedsSownContainerView)
        mainStackView.addArrangedSubview(germinationCounterContainerView)
        mainStackView.addArrangedSubview(deathCounterContainerView)
        mainStackView.addArrangedSubview(chartContainerView)
        
        mainStackView.spacing = 0
        
        setupDateSownView()
        setupNumberOfSeedsSownLabel()
        setupGerminationContainer()
        setupDeathContainer()
        setupChartContainer()
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
    }
    
    /// Setup the date sown label.
    private func setupDateSownView() {
        dateSownContainerView.addSubview(dateSownLabel)
        
        dateSownContainerView.snp.makeConstraints({ make in
            make.top.equalTo(mainStackView)
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
        })
        dateSownLabel.snp.makeConstraints({ make in
            make.top.equalTo(dateSownContainerView).inset(verticalSeparation)
            make.bottom.equalTo(dateSownContainerView).inset(verticalSeparation)
            make.leading.equalTo(dateSownContainerView).inset(sideInset)
            make.trailing.equalTo(dateSownContainerView).inset(sideInset)
        })
        
        dateSownLabel.textColor = .white
        dateSownLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        dateSownLabel.textAlignment = .center
        dateSownLabel.backgroundColor = infoViewPal.green
        dateSownLabel.layer.cornerRadius = cornerRadius
        dateSownLabel.layer.masksToBounds = true
    }
    
    /// Setup the date sown label.
    private func setupNumberOfSeedsSownLabel() {
        numberOfSeedsSownContainerView.addSubview(numberOfSeedsSownLabel)
        
        numberOfSeedsSownContainerView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(dateSownContainerView)
        })
        numberOfSeedsSownLabel.snp.makeConstraints({ make in
            make.top.equalTo(numberOfSeedsSownContainerView).inset(verticalSeparation)
            make.bottom.equalTo(numberOfSeedsSownContainerView).inset(verticalSeparation)
            make.leading.equalTo(numberOfSeedsSownContainerView).inset(sideInset)
            make.trailing.equalTo(numberOfSeedsSownContainerView).inset(sideInset)
        })
        
        numberOfSeedsSownLabel.textColor = .white
        numberOfSeedsSownLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        numberOfSeedsSownLabel.textAlignment = .center
        numberOfSeedsSownLabel.backgroundColor = infoViewPal.green
        numberOfSeedsSownLabel.layer.cornerRadius = cornerRadius
        numberOfSeedsSownLabel.layer.masksToBounds = true
    }
    
    /// Setup the germination container view.
    private func setupGerminationContainer() {
        germinationCounterContainerView.addArrangedSubview(germinationCounterLabel)
        germinationCounterContainerView.addArrangedSubview(germinationStepper)
        germinationCounterContainerView.alignment = .fill
        germinationCounterContainerView.axis = .horizontal
        germinationCounterContainerView.spacing = 5
        
        germinationCounterContainerView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(dateSownContainerView)
        })
        germinationCounterLabel.snp.makeConstraints({ make in
            make.leading.equalTo(germinationCounterContainerView)
            make.centerY.equalTo(germinationCounterContainerView)
        })
        germinationStepper.snp.makeConstraints({ make in
            make.trailing.equalTo(germinationCounterContainerView)
            make.centerY.equalTo(germinationCounterLabel)
        })
        germinationStepperBackgroundView.snp.makeConstraints({ make in
            make.top.equalTo(germinationCounterContainerView).inset(verticalSeparation)
            make.bottom.equalTo(germinationCounterContainerView).inset(verticalSeparation)
            make.leading.equalTo(germinationCounterContainerView).inset(sideInset)
            make.trailing.equalTo(germinationCounterContainerView).inset(sideInset)
        })
        
        germinationCounterLabel.textAlignment = .center
        germinationCounterLabel.textColor = .white
        germinationCounterLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        germinationStepper.minimumValue = 0
        germinationStepper.stepValue = 1
        
        germinationStepperBackgroundView.backgroundColor = infoViewPal.green
        germinationStepperBackgroundView.layer.cornerRadius = cornerRadius
        germinationStepperBackgroundView.layer.masksToBounds = true
    }
    
    /// Setup the death container view.
    private func setupDeathContainer() {
        deathCounterContainerView.addArrangedSubview(deathCounterLabel)
        deathCounterContainerView.addArrangedSubview(deathStepper)
        deathCounterContainerView.alignment = .fill
        deathCounterContainerView.axis = .horizontal
        deathCounterContainerView.spacing = 5
        
        deathCounterContainerView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(dateSownContainerView)
        })
        deathCounterLabel.snp.makeConstraints({ make in
            make.leading.equalTo(deathCounterContainerView)
            make.centerY.equalTo(deathCounterContainerView)
        })
        deathStepper.snp.makeConstraints({ make in
            make.trailing.equalTo(deathCounterContainerView)
            make.centerY.equalTo(deathCounterContainerView)
        })
        deathStepperBackgroundView.snp.makeConstraints({ make in
            make.top.equalTo(deathCounterContainerView).inset(verticalSeparation)
            make.bottom.equalTo(deathCounterContainerView).inset(verticalSeparation)
            make.leading.equalTo(deathCounterContainerView).inset(sideInset)
            make.trailing.equalTo(deathCounterContainerView).inset(sideInset)
        })
        
        deathCounterLabel.textAlignment = .center
        deathCounterLabel.textColor = .white
        deathCounterLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        deathStepper.minimumValue = 0
        deathStepper.stepValue = 1
        deathStepper.tintColor = .white
        
        deathStepperBackgroundView.backgroundColor = infoViewPal.green
        deathStepperBackgroundView.layer.cornerRadius = cornerRadius
        deathStepperBackgroundView.layer.masksToBounds = true
    }
    
    /// Setup the container view for the chart.
    private func setupChartContainer() {
        chartContainerView.snp.makeConstraints({ make in
            make.bottom.equalTo(mainStackView)
            make.height.equalTo(halfViewFrameHeight)
        })
    }
    
    
    /// Set up the information for a plant object.
    func configureViewFor(_ plant: Plant) {
        set(dateSownLabelTo: plant.dateOfSeedSowing)
        set(numberOfSeedlingsTo: plant.numberOfSeedsSown)
        set(numberOfGerminationsTo: plant.numberOfGerminations)
        set(numberOfDeathsTo: plant.numberOfDeaths)
    }
    
    /// Set the date of sowing label.
    func set(dateSownLabelTo date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = "Date sown: \(dateFormatter.string(from: date))"
        dateSownLabel.text = text
    }
    
    
    /// Set the number of seedlings label.
    func set(numberOfSeedlingsTo num: Int) {
        numberOfSeedsSownLabel.text = "Num. seeds sown: \(num)"
    }
    
    /// Set the number of germinations.
    ///
    /// This sets both the label and the stepper value.
    func set(numberOfGerminationsTo num: Int) {
        germinationCounterLabel.text = "Num. of germinations: \(num)"
        germinationStepper.value = Double(num)
    }
    
    /// Set the number of deaths.
    ///
    /// This sets both the label and the stepper value.
    func set(numberOfDeathsTo num: Int) {
        deathCounterLabel.text = "Num. of deaths: \(num)"
        deathStepper.value = Double(num)
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
