//
//  ViewController.swift
//  SwiftChartViewDemo
//
//  Created by ZHOU DENGFENG on 1/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import SwiftChartView

class ViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        chartView.xLabels = ["2017/11/01", "2017/11/02", "2017/11/03", "2017/11/04", "2017/11/05", "2017/11/06", "2017/11/07"]
//        chartView.yDatas = [0.0, 0.0, 325.0, 25.0, 0.0, 0.0, 75.0]
    }
    
    @IBAction func strokeChart() {
        var chartPoints: [ChartPoint] = []
        for i in 1 ... 7 {
            let value = Double(arc4random_uniform(100))
            let chartPoint = ChartPoint(label: "11-0\(i)", value: value)
            chartPoints.append(chartPoint)
        }
        
        chartView.chartPoints = chartPoints
        chartView.strokeChart()
    }
}

