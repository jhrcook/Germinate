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


fileprivate enum EventType {
    case germination, death
}

class ChartViewController: UIViewController {

    var plant: Plant
    
    var germinationLineChartView = LineChartView()
    
    private var chartHasBeenDrawnPreviously = false
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.current
        return df
    }()
    
    
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

        // Do any additional setup after loading the view.
        setupView()
    }
    
    
    func setupView() {
        view.addSubview(germinationLineChartView)
        germinationLineChartView.snp.makeConstraints({ make in
            make.edges.equalTo(view).inset(20)
        })
        
        if #available(iOS 13, *) {
            germinationLineChartView.backgroundColor = .tertiarySystemBackground
            germinationLineChartView.layer.cornerRadius = 8
            germinationLineChartView.layer.masksToBounds = true
        }
    }
    
    
    func updateChart() {
        drawChart(withAnimation: false)
    }
    
    
    func drawChart(withAnimation animate: Bool) {
        
        var startDate = plant.dateOfSeedSowing
        let today = Date()
        
        // break early if today is the same day at start of germination
        if Calendar.current.isDate(startDate, inSameDayAs: today) {
            germinationLineChartView.noDataText = "Good luck!\n(There's no data to present, yet.)"
            germinationLineChartView.noDataFont = UIFont.preferredFont(forTextStyle: .headline)
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
        germinationLineChartView.data = data
        
        germinationLineChartView.leftAxis.axisMinimum = 0.0
        germinationLineChartView.rightAxis.axisMinimum = 0.0
        germinationLineChartView.isUserInteractionEnabled = true
        germinationLineChartView.xAxis.labelPosition = .bottom
        germinationLineChartView.xAxis.labelFont = UIFont.preferredFont(forTextStyle: .footnote)
        germinationLineChartView.leftAxis.labelFont = UIFont.preferredFont(forTextStyle: .footnote)
        germinationLineChartView.rightAxis.labelFont = UIFont.preferredFont(forTextStyle: .footnote)
        germinationLineChartView.xAxis.axisLineWidth = 2
        germinationLineChartView.leftAxis.axisLineWidth = 2
        germinationLineChartView.rightAxis.axisLineWidth = 2
        
        if #available(iOS 13, *) {
            germinationLineChartView.xAxis.labelTextColor = .label
            germinationLineChartView.leftAxis.labelTextColor = .label
            germinationLineChartView.rightAxis.labelTextColor = .label
            germinationLineChartView.noDataTextColor = .label
            germinationLineChartView.xAxis.axisLineColor = .systemGray
            germinationLineChartView.leftAxis.axisLineColor = .systemGray
            germinationLineChartView.rightAxis.axisLineColor = .systemGray
            germinationLineChartView.legend.textColor = .label
        }
        
        if (animate) {
            germinationLineChartView.animate(xAxisDuration: 1.0, easingOption: .easeInBounce)
        }
    }
    
    
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


