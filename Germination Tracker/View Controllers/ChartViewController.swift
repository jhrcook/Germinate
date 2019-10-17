//
//  ChartViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/24/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import Charts
import ChameleonFramework
import SnapKit

/// The different events that can be used. Currently, the app only shows germinations and deaths.
fileprivate enum EventType {
    /// Germination events.
    case germination
    /// Death events.
    case death
}


/**
 The controller for the chart view.
 
 A chart is plotted with two lines, one for germinations and one for deaths.
 The lines are cumulative plots to show the rate of germination and death of the seedlings.
 */
class ChartViewController: UIViewController {

    /// Plant object to show.
    /// This object is passed to several children view controllers.
    var plant: Plant
    
    /// The chart view being displayed.
    var eventLineChartView = LineChartView()
    
    /// A boolean value for if the chart has been drawn before. It is used to prevent re-animation for every
    /// update to the data.
    private var chartHasBeenDrawnPreviously = false
    
    /// A date formatter that uses the "yyyy-MM-dd" format in the current time zone.
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.current
        return df
    }()
    
    
    /// Initialize the controller with a plant object.
    /// It automatically creates and draws the chart right away.
    init(plant: Plant) {
        self.plant = plant
        super.init(nibName: nil, bundle: nil)
        drawChart(withAnimation: true)
        chartHasBeenDrawnPreviously = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        // Default to letting the user interact with the chart
        eventLineChartView.isUserInteractionEnabled = true
    }
    
    
    /// Set up the view. This needs only be run once, and is automatically run when the view has loaded.
    private func setupView() {
        // Add the chart view to the default view for this view controller.
        view.addSubview(eventLineChartView)
        eventLineChartView.snp.makeConstraints({ make in
            make.edges.equalTo(view).inset(10)
        })
        
        if #available(iOS 13, *) {
            eventLineChartView.backgroundColor = .tertiarySystemBackground
            eventLineChartView.layer.cornerRadius = 8
            eventLineChartView.layer.masksToBounds = true
        }
    }
    
    
    /// Update the chart (without animation).
    func updateChart() {
        drawChart(withAnimation: false)
    }
    
    
    /// The function responsible for drawing the chart.
    /// - parameter animate: Whether the animate the drawing or not.
    func drawChart(withAnimation animate: Bool) {
        
        var startDate = plant.dateOfSeedSowing
        let today = Date()
        
        // break early if today is the same day at start of germination
        if Calendar.current.isDate(startDate, inSameDayAs: today) {
            eventLineChartView.noDataText = "Good luck!\n(There's no data to present, yet.)"
            eventLineChartView.noDataFont = UIFont.preferredFont(forTextStyle: .headline)
            return
        }
        
        // x-values for plot
        var allDatesSinceBeginning  = [Date]()
        while startDate <= today {
            allDatesSinceBeginning.append(startDate)
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
        allDatesSinceBeginning.append(startDate)    
        
        allDatesSinceBeginning = allDatesSinceBeginning.sorted(by: { $0 < $1 })
        
        let cumulativeGerminationCount = calculateCumulativeCounts(forDatesManager: plant.germinationDatesManager, forDates: allDatesSinceBeginning)
        let cumulativeDeathCount = calculateCumulativeCounts(forDatesManager: plant.deathDatesManager, forDates: allDatesSinceBeginning)
        
        
        if allDatesSinceBeginning.count != cumulativeGerminationCount.count {
            fatalError("The number of dates (x) does not equal the number of cumulative germ. counts (y).")
        }
        if allDatesSinceBeginning.count != cumulativeDeathCount.count {
            fatalError("The number of dates (x) does not equal the number of cumulative death counts (y).")
        }
        
        
        // turn germination data into chart data entry
        var germinationValues = [ChartDataEntry]()
        for i in 1..<cumulativeGerminationCount.count {
            germinationValues.append(ChartDataEntry(x: Double(i), y: cumulativeGerminationCount[i]))
        }
        
        var germinationSet = LineChartDataSet(entries: germinationValues, label: "Germinations")
        styleLineDataSet(&germinationSet, forEvent: .germination)
        
        // turn death data into chart data entry
        var deathValues = [ChartDataEntry]()
        for i in 1..<cumulativeDeathCount.count {
            deathValues.append(ChartDataEntry(x: Double(i), y: cumulativeDeathCount[i]))
        }
        
        var deathSet = LineChartDataSet(entries: deathValues, label: "Deaths")
        styleLineDataSet(&deathSet, forEvent: .death)
        
        
        let data = LineChartData(dataSets: [germinationSet, deathSet])
        eventLineChartView.data = data
        
        eventLineChartView.leftAxis.axisMinimum = 0.0
        eventLineChartView.rightAxis.axisMinimum = 0.0
        eventLineChartView.xAxis.labelPosition = .bottom
        eventLineChartView.xAxis.labelFont = UIFont.preferredFont(forTextStyle: .footnote)
        eventLineChartView.leftAxis.labelFont = UIFont.preferredFont(forTextStyle: .footnote)
        eventLineChartView.rightAxis.labelFont = UIFont.preferredFont(forTextStyle: .footnote)
        eventLineChartView.xAxis.axisLineWidth = 2
        eventLineChartView.leftAxis.axisLineWidth = 2
        eventLineChartView.rightAxis.axisLineWidth = 2
        
        if #available(iOS 13, *) {
            eventLineChartView.xAxis.labelTextColor = .label
            eventLineChartView.leftAxis.labelTextColor = .label
            eventLineChartView.rightAxis.labelTextColor = .label
            eventLineChartView.noDataTextColor = .label
            eventLineChartView.xAxis.axisLineColor = .systemGray
            eventLineChartView.leftAxis.axisLineColor = .systemGray
            eventLineChartView.rightAxis.axisLineColor = .systemGray
            eventLineChartView.legend.textColor = .label
        }
        
        if (animate) {
            eventLineChartView.animate(xAxisDuration: 0.2, yAxisDuration: 0.2, easingOption: .linear)
        }
    }
    
    
    /// Style the line data set
    /// - parameter dataSet: The data set to style.
    /// - parameter eventType: The type of event of the data set. The line color is determined by the event type.
    private func styleLineDataSet(_ dataSet: inout LineChartDataSet, forEvent eventType: EventType) {
        // customize germinationSet
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 2
        dataSet.axisDependency = .left
        dataSet.mode = .horizontalBezier
        
        switch eventType {
        case .germination:
            if #available(iOS 13, *) {
                dataSet.colors = [UIColor.systemBlue]
            } else {
                dataSet.colors = [FlatMintDark()]
            }
        case .death:
            if #available(iOS 13, *) {
                dataSet.colors = [UIColor.systemRed]
            } else {
                dataSet.colors = [FlatRed()]
            }
        }
        
    }
    
    
    /// Calculates the cumulative number of events over the dates provided.
    /// - parameter datesManager: The manager of the events being counted.
    /// - parameter dates: The dates to accumulate the events over.
    private func calculateCumulativeCounts(forDatesManager datesManager: DateCounterManager, forDates dates: [Date]) -> [Double] {
        // initialize empty array and counter
        var cumulativeCount = [Double]()
        var totalCount: Double = 0
        
        // build cumulative counts over all dates
        for day in dates {
            totalCount += Double(datesManager.numberOfEvents(onDate: day) ?? 0)
            cumulativeCount.append(totalCount)
        }
        
        return cumulativeCount
    }
}


