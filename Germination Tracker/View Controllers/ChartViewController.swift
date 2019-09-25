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
        
        // let xVals = plant.seedGerminationDates
        /// TODO: count germinations cumulatively
        
        // Test data
        let count = 100
        let range: UInt32 = 30
        
        let now = Date().timeIntervalSince1970
        let hourSeconds: TimeInterval = 3600
        let from = now - (Double(count) / 2) * hourSeconds
        let to = now + (Double(count) / 2) * hourSeconds
        let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
        let y = arc4random_uniform(range) + 50
        return ChartDataEntry(x: x, y: Double(y))
                }
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        germinationLineChartView.data = data
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
