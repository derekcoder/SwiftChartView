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
    
    @IBAction func strokeChart() {
        var chartPoints: [ChartPoint] = []
        for i in 1 ... 7 {
            let value = Double(arc4random_uniform(100))
            let chartPoint = ChartPoint(label: "11-0\(i)", value: value)
            chartPoints.append(chartPoint)
        }
        
        chartView.isCurved = true
        chartView.pointStyle = .circle
        chartView.chartPoints = chartPoints
        chartView.strokeChart()
    }
}

