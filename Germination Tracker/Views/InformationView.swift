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

/// A protocol for the communication between the `InformationView` and its view controller.
protocol InformationViewDelegate {
    func dateSownLabelWasTapped(_ label: UILabel)
    func numberOfSeedsSownLabelWasTapped(_ label: UILabel)
    func germinationStepperValueDidChange(_ stepper: UIStepper)
    func deathStepperValueDidChange(_ stepper: UIStepper)
    func germinationCounterLabelWasTapped(_ label: UILabel)
    func deathCounterLabelWasTapped(_ label: UILabel)
}


/**
 A view to show the general information about a set of seedlings.
 
 It contains a chart on the top showing the rate of germination and death of the
 seedlings. This is followed by labels showing the sowing date, number of
 seeds sown, and counters for germination and death. There are many tap targets
 and a lot of user interaction.
 */
class InformationView: UIView {
    
    /// The delegate should be the controller for the view.
    var delegate: InformationViewDelegate?
    
    /// The stack view that contains everything.
    var mainStackView = UIStackView()
    
    /// The background for the labels underneath the chart.
    var labelBackgroundView = UIView()
    
    /// A container for the date sown label: `dateSownLabel`.
    var dateSownContainerView = UIView()

    /// The label that shows the date.
    var dateSownLabel = UILabel()
    
    /// A container for the label with the number of seeds: `numberOfSeedsSownLabel`.
    var numberOfSeedsSownContainerView = UIView()
    /// The label showing the number of seeds.
    var numberOfSeedsSownLabel = UILabel()
    
    /// The container for the components that comprise the germination counter.
    var germinationCounterContainerView = UIView()
    /// A stack view for organizing the components of the germination counter.
    /// This sits within the `germinationCounterContainerView`,
    var germinationCounterStackView = UIStackView()
    /// The label showing the number of germinations.
    var germinationCounterLabel = UILabel()
    /// The stepper for the germinations.
    var germinationStepper = UIStepper()
    /// A background view for the germination counter components.
    var germinationStepperBackgroundView = UIView()
    
    /// The container for the components that comprise the death counter.
    var deathCounterContainerView = UIView()
    /// A stack view for organizing the components of the death counter.
    /// This sits within the `deathCounterContainerView`,
    var deathCounterStackView = UIStackView()
    /// The label showing the number of deaths.
    var deathCounterLabel = UILabel()
    /// The stepper for the deaths.
    var deathStepper = UIStepper()
    /// A background view for the death counter components.
    var deathStepperBackgroundView = UIView()
    
    /// The view holding the chart view.
    var chartContainerView = UIView()
    
    /// A value for half the height of the view. It gets set after the view loads.
    private var halfViewFrameHeight: CGFloat = 0
    /// The inset of all subviews from the edges.
    private var sideInset: CGFloat = 15
    /// The vertical spacing between subviews.
    private var verticalSeparation: CGFloat = 5
    
    /// The corner radius for labels and background views.
    private var cornerRadius: CGFloat = 8
    
    
    // Set up the view after initialization.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupInteractions()
    }
    
    
    // Set up the view after initialization.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setupInteractions()
    }
    
    
    /// Setup the main stack view.
    func setupStackView() {
        
        halfViewFrameHeight = frame.height / 2.0
        
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
        
        setStyleFor(view: &deathStepperBackgroundView)
    }
    
    
    /// Set up the background view of the labels.
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
    
    /// Set the style of views to a standardized appearance.
    private func setStyleFor(view: inout UIView) {
        if #available(iOS 13, *) {
            view.backgroundColor = .secondarySystemGroupedBackground
        } else {
            view.backgroundColor = .lightGray
        }
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    
    /// Set the style of labels to a standardized appearance.
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
    /// This sets both the label and the stepper value.
    func set(numberOfGerminationsTo num: Int) {
        germinationCounterLabel.text = "Num. of germinations: \(num)"
        germinationStepper.value = Double(num)
    }
    
    
    /// Set the number of deaths.
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
    /// Calls the delegate's `dateSownLabelWasTapped(_: UILabel)` method.
    @objc private func dateSownLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.dateSownLabelWasTapped(dateSownLabel)
    }
    
    
    /// Respond to the number of seeds label being tapped.
    /// Calls the delegate's `numberOfSeedsSownLabelWasTapped(_: UILabel)` method.
    @objc private func numberOfSeedsSownLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.numberOfSeedsSownLabelWasTapped(numberOfSeedsSownLabel)
    }
    
    
    /// Respond to the label for the germination counter being tapped.
    /// Calls the delegate's `germinationCounterLabelWasTapped(_: UILabel)` method.
    @objc private func germinationCounterLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.germinationCounterLabelWasTapped(germinationCounterLabel)
    }
    
    
    /// Respond to the label for the death counter being tapped.
    /// Calls the delegate's `deathCounterLabelWasTapped(_: UILabel)` method.
    @objc private func deathCounterLabelWasTapped() {
        guard let delegate = delegate else { return }
        delegate.deathCounterLabelWasTapped(deathCounterLabel)
    }
    
    
    /// Respond the the change in value of a stepper.
    /// This is the target for both the germination and death steppers.
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
