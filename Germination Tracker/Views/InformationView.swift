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


protocol InformationViewDelegate {
    func dateSownLabelWasTapped(_ label: UILabel)
    func numberOfSeedsSownLabelWasTapped(_ label: UILabel)
    func germinationStepperValueDidChange(_ stepper: UIStepper)
    func deathStepperValueDidChange(_ stepper: UIStepper)
    func germinationCounterLabelWasTapped(_ label: UILabel)
    func deathCounterLabelWasTapped(_ label: UILabel)
}


class InformationView: UIView {
    
    var delegate: InformationViewDelegate?
    
    var mainStackView = UIStackView()
    
    var labelBackgroundView = UIView()
    
    var dateSownContainerView = UIView()
    var dateSownLabel = UILabel()
    
    var numberOfSeedsSownContainerView = UIView()
    var numberOfSeedsSownLabel = UILabel()
    
    var germinationCounterContainerView = UIView()
    var germinationCounterStackView = UIStackView()
    var germinationCounterLabel = UILabel()
    var germinationStepper = UIStepper()
    var germinationStepperBackgroundView = UIView()
    
    var deathCounterContainerView = UIView()
    var deathCounterStackView = UIStackView()
    var deathCounterLabel = UILabel()
    var deathStepper = UIStepper()
    var deathStepperBackgroundView = UIView()
    
    var chartContainerView = UIView()
    
    var halfViewFrameHeight: CGFloat = 0
    var heightOfTopViews: CGFloat = 0
    var sideInset: CGFloat = 15
    var verticalSeparation: CGFloat = 5
    
    var cornerRadius: CGFloat = 8
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupInteractions()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Setup the main stack view.
    func setupStackView() {
        
        halfViewFrameHeight = frame.height / 2.0
        heightOfTopViews = halfViewFrameHeight / 4.0
        
        addSubview(labelBackgroundView)
        addSubview(germinationStepperBackgroundView)
        addSubview(deathStepperBackgroundView)
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        mainStackView.addArrangedSubview(chartContainerView)
        mainStackView.addArrangedSubview(dateSownContainerView)
        mainStackView.addArrangedSubview(numberOfSeedsSownContainerView)
        mainStackView.addArrangedSubview(germinationCounterContainerView)
        mainStackView.addArrangedSubview(deathCounterContainerView)
        
        mainStackView.spacing = 0
        
        setupChartContainer()
        setupDateSownView()
        setupNumberOfSeedsSownLabel()
        setupGerminationContainer()
        setupDeathContainer()
        
        setupLabelBackgroundView()
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
    }
    
    
    /// Setup the container view for the chart.
    private func setupChartContainer() {
        chartContainerView.snp.makeConstraints({ make in
            make.top.equalTo(mainStackView)
            make.height.equalTo(halfViewFrameHeight)
        })
    }
    
    
    /// Setup the date sown label.
    private func setupDateSownView() {
        dateSownContainerView.addSubview(dateSownLabel)
        
        dateSownContainerView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
        })
        dateSownLabel.snp.makeConstraints({ make in
            make.top.equalTo(dateSownContainerView).inset(verticalSeparation)
            make.bottom.equalTo(dateSownContainerView).inset(verticalSeparation)
            make.leading.equalTo(dateSownContainerView).inset(sideInset)
            make.trailing.equalTo(dateSownContainerView).inset(sideInset)
        })
        
        setStyleFor(label: &dateSownLabel)
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
        
        setStyleFor(label: &numberOfSeedsSownLabel)
    }
    
    
    /// Setup the germination container view.
    private func setupGerminationContainer() {
        germinationCounterContainerView.addSubview(germinationCounterStackView)
        
        germinationCounterStackView.addArrangedSubview(germinationCounterLabel)
        germinationCounterStackView.addArrangedSubview(germinationStepper)
        germinationCounterStackView.alignment = .center
        germinationCounterStackView.distribution = .fill
        germinationCounterStackView.axis = .horizontal
        germinationCounterStackView.spacing = 5
        germinationCounterStackView.isLayoutMarginsRelativeArrangement = true
        germinationCounterStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)
        
        germinationCounterContainerView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(dateSownContainerView)
        })
        germinationCounterStackView.snp.makeConstraints({ make in
            make.top.equalTo(germinationCounterContainerView)
            make.bottom.equalTo(germinationCounterContainerView)
            make.leading.equalTo(germinationCounterContainerView).inset(sideInset)
            make.trailing.equalTo(germinationCounterContainerView).inset(sideInset)
        })
        germinationCounterLabel.snp.makeConstraints({ make in
            make.leading.equalTo(germinationCounterStackView)
            make.centerY.equalTo(germinationCounterStackView)
        })
        germinationStepper.snp.makeConstraints({ make in
            make.trailing.equalTo(germinationCounterStackView)
            make.centerY.equalTo(germinationCounterLabel)
        })
        germinationStepperBackgroundView.snp.makeConstraints({ make in
            make.top.equalTo(germinationCounterContainerView).inset(verticalSeparation)
            make.bottom.equalTo(germinationCounterContainerView).inset(verticalSeparation)
            make.leading.equalTo(germinationCounterContainerView).inset(sideInset)
            make.trailing.equalTo(germinationCounterContainerView).inset(sideInset)
        })
        
        
        germinationCounterLabel.textAlignment = .center
        germinationCounterLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        germinationStepper.minimumValue = 0
        germinationStepper.stepValue = 1

        setStyleFor(view: &germinationStepperBackgroundView)
    }
    
    
    /// Setup the death container view.
    private func setupDeathContainer() {
        deathCounterContainerView.addSubview(deathCounterStackView)
        
        deathCounterStackView.addArrangedSubview(deathCounterLabel)
        deathCounterStackView.addArrangedSubview(deathStepper)
        deathCounterStackView.alignment = .center
        deathCounterStackView.distribution = .fill
        deathCounterStackView.axis = .horizontal
        deathCounterStackView.spacing = 5
        deathCounterStackView.isLayoutMarginsRelativeArrangement = true
        deathCounterStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)
        
        deathCounterContainerView.snp.makeConstraints({ make in
            make.leading.equalTo(mainStackView)
            make.trailing.equalTo(mainStackView)
            make.height.equalTo(dateSownContainerView)
            make.bottom.equalTo(mainStackView)
        })
        deathCounterStackView.snp.makeConstraints({ make in
            make.top.equalTo(deathCounterContainerView)
            make.bottom.equalTo(deathCounterContainerView)
            make.leading.equalTo(deathCounterContainerView).inset(sideInset)
            make.trailing.equalTo(deathCounterContainerView).inset(sideInset)
        })
        deathCounterLabel.snp.makeConstraints({ make in
            make.leading.equalTo(deathCounterStackView)
            make.centerY.equalTo(deathCounterStackView)
        })
        deathStepper.snp.makeConstraints({ make in
            make.trailing.equalTo(deathCounterStackView)
            make.centerY.equalTo(deathCounterStackView)
        })
        deathStepperBackgroundView.snp.makeConstraints({ make in
            make.top.equalTo(deathCounterContainerView).inset(verticalSeparation)
            make.bottom.equalTo(deathCounterContainerView).inset(verticalSeparation)
            make.leading.equalTo(deathCounterContainerView).inset(sideInset)
            make.trailing.equalTo(deathCounterContainerView).inset(sideInset)
        })
        
        deathCounterLabel.textAlignment = .center
        deathCounterLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        deathStepper.minimumValue = 0
        deathStepper.stepValue = 1
//        deathStepper.tintColor = .white
        
        setStyleFor(view: &deathStepperBackgroundView)
    }
    
    
    private func setupLabelBackgroundView() {
        setStyleFor(view: &labelBackgroundView)
        if #available(iOS 13, *) {
            labelBackgroundView.backgroundColor = .systemGroupedBackground
        } else {
            labelBackgroundView.backgroundColor = .gray
        }
        
        let bufferSize = 8
        
        labelBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(dateSownLabel).offset(-bufferSize)
            make.leading.equalTo(dateSownLabel).offset(-bufferSize)
            make.trailing.equalTo(dateSownLabel).offset(bufferSize)
            make.bottom.equalTo(deathStepperBackgroundView).offset(bufferSize)
        }
    }
    
    
    private func setStyleFor(view: inout UIView) {
        if #available(iOS 13, *) {
            view.backgroundColor = .secondarySystemGroupedBackground
        } else {
            view.backgroundColor = .lightGray
        }
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    
    private func setStyleFor(label: inout UILabel) {
        if #available(iOS 13, *) {
            label.backgroundColor = .secondarySystemGroupedBackground
        } else {
            label.backgroundColor = .lightGray
        }
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
    }
    
    
    /// Set up the information for a plant object.
    func configureViewFor(_ plant: Plant) {
        set(dateSownLabelTo: plant.dateOfSeedSowing)
        set(numberOfSeedlingsTo: plant.numberOfSeedsSown)
        set(numberOfGerminationsTo: plant.germinationDatesManager.totalCount)
        set(numberOfDeathsTo: plant.deathDatesManager.totalCount)
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
    
    
    /// Setup the functions that pass UI with labels and steppers to the delegate
    private func setupInteractions() {
        // set up date sown label
        dateSownLabel.isUserInteractionEnabled = true
        let tapDateSown = UITapGestureRecognizer(target: self, action: #selector(dateSownLabelWasTapped))
        dateSownLabel.addGestureRecognizer(tapDateSown)
        
        // set up number of seeds label
        numberOfSeedsSownLabel.isUserInteractionEnabled = true
        let tapNumberSown = UITapGestureRecognizer(target: self, action: #selector(numberOfSeedsSownLabelWasTapped))
        numberOfSeedsSownLabel.addGestureRecognizer(tapNumberSown)
        
        // set up germinations label recognition
        germinationCounterLabel.isUserInteractionEnabled = true
        let tapGerminationLabel = UITapGestureRecognizer(target: self, action: #selector(germinationCounterLabelWasTapped))
        germinationCounterLabel.addGestureRecognizer(tapGerminationLabel)
        
        // set up deaths label recognition
        deathCounterLabel.isUserInteractionEnabled = true
        let tapDeathLabel = UITapGestureRecognizer(target: self, action: #selector(deathCounterLabelWasTapped))
        deathCounterLabel.addGestureRecognizer(tapDeathLabel)
        
        // set stepper targets
        germinationStepper.addTarget(self, action: #selector(stepperValueDidChange), for: .valueChanged)
        deathStepper.addTarget(self, action: #selector(stepperValueDidChange), for: .valueChanged)
    }
    
    
    /// Respond to the date of sowing label being tapped.
    ///
    /// Calls the deleage's `dateSownLabelWasTapped(_ label: UILabel)` method.
    @objc private func dateSownLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.dateSownLabelWasTapped(dateSownLabel)
    }
    
    
    /// Respond to the number of seeds label being tapped.
    ///
    /// Calls the deleage's `numberOfSeedsSownLabelWasTapped(_ label: UILabel)` method.
    @objc private func numberOfSeedsSownLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.numberOfSeedsSownLabelWasTapped(numberOfSeedsSownLabel)
    }
    
    
    @objc private func germinationCounterLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.germinationCounterLabelWasTapped(germinationCounterLabel)
    }
    
    
    @objc private func deathCounterLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.deathCounterLabelWasTapped(deathCounterLabel)
    }
    
    
    /// Respond the the change in value of a stepper.
    /// This is the target for both the germination and death steppers.
    ///
    /// Calls the delegate's appropriate method for dealing with the steppers.
    @objc private func stepperValueDidChange(_ stepper: UIStepper) {
        guard let delegate = delegate else { return }
        if stepper == germinationStepper {
            delegate.germinationStepperValueDidChange(stepper)
        } else if stepper == deathStepper {
            delegate.deathStepperValueDidChange(stepper)
        }
    }
    
}
