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
        
        // y-values for plot
        var cumulativeGerminationCount = [Double]()
        var totalGermCount: Double = 0
        for day in allDatesSinceBeginning {
            var dayGermCount: Double = 0
             for germDate in plant.seedGerminationDates {
                if Calendar.current.isDate(day, inSameDayAs: germDate) { dayGermCount += 1 }
            }
            
            totalGermCount += dayGermCount
            cumulativeGerminationCount.append(totalGermCount)
        }
        
        
        if allDatesSinceBeginning.count != cumulativeGerminationCount.count {
            fatalError("The number of dates (x) does not equal the number of cumulative germ. counts (y).")
        }
        
        
        // turn into chart data entry
        var values = [ChartDataEntry]()
        for i in 1..<cumulativeGerminationCount.count {
            values.append(ChartDataEntry(x: Double(i), y: cumulativeGerminationCount[i]))
        }
                
        let set1 = LineChartDataSet(entries: values, label: "Germinations")
        
        // customize set1
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawValuesEnabled = false
        set1.lineWidth = 2
        set1.axisDependency = .left
        
        if #available(iOS 13, *) {
            set1.colors = [UIColor.systemBlue]
        } else {
            set1.colors = [FlatMintDark()]
        }
        
        let data = LineChartData(dataSet: set1)
        germinationLineChartView.data = data
                
        germinationLineChartView.isUserInteractionEnabled = false
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
        }
        
        if (animate) {
            germinationLineChartView.animate(xAxisDuration: 1.0, easingOption: .linear)
        }
    }
}


