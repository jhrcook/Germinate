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

    weak var plant: Plant!
    
    var germinationLineChartView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setGerminationLineChart()
    }
    
    
    func setupView() {
        view.addSubview(germinationLineChartView)
        germinationLineChartView.snp.makeConstraints({ make in
            make.edges.equalTo(view).inset(20)
        })
    }
    
    
    func setGerminationLineChart() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        var startDate = plant.dateOfSeedSowing
        let nowDate = Date()
        
        // break early if today is the same day at start of germination
        if Calendar.current.isDate(startDate, inSameDayAs: nowDate) {
            germinationLineChartView.noDataText = "Good luck!"
            return
        }
        
        // x-values for plot
        var allDatesSinceBeginning  = [Date]()
        while startDate <= nowDate {
            allDatesSinceBeginning.append(startDate)
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
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
        set1.colors = [FlatMintDark()]
        
        let data = LineChartData(dataSet: set1)
        germinationLineChartView.data = data
        
        germinationLineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInCubic)
        
        
//        // Test data
//        let count = 100
//        let range: UInt32 = 30
//
//        let now = Date().timeIntervalSince1970
//        let hourSeconds: TimeInterval = 3600
//        let from = now - (Double(count) / 2) * hourSeconds
//        let to = now + (Double(count) / 2) * hourSeconds
//        let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
//            let y = arc4random_uniform(range) + 50
//            return ChartDataEntry(x: x, y: Double(y))
//        }
//        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
//        set1.axisDependency = .left
//        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
//        set1.lineWidth = 1.5
//        set1.drawCirclesEnabled = false
//        set1.drawValuesEnabled = false
//        set1.fillAlpha = 0.26
//        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
//        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//        set1.drawCircleHoleEnabled = false
//
//        let data = LineChartData(dataSet: set1)
//        data.setValueTextColor(.white)
//        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
//
//        germinationLineChartView.data = data
    }
}
