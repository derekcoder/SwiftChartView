//
//  BarChartViewController.swift
//  SwiftChartViewDemo
//
//  Created by Julie on 9/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import SwiftChartView

class BarChartViewController: UIViewController {

    @IBOutlet weak var chartView: BarChartView!
    
    private let values: [Double] = [49.5, 80.0, 70.8, 100.0, 43.0, 30.0, 60.0]
    private lazy var chartPoints: [ChartPoint] = {
        var chartPoints: [ChartPoint] = []
        for i in 0 ..< values.count {
            let chartPoint = ChartPoint(label: "11-0\(i+1)", value: values[i])
            chartPoints.append(chartPoint)
        }
        return chartPoints
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.chartPoints = chartPoints
    }
    
    @IBAction func strokeChart() {
        chartView.strokeChart(animated: true)
    }
    
    @IBAction func lineWidthChanged(_ sender: UISlider) {
        chartView.lineWidth = CGFloat(sender.value)
    }
    
    @IBAction func tapLineColorButton(_ sender: UIButton) {
        chartView.lineColor = sender.backgroundColor!
    }
    
    @IBAction func tapAxisColorButton(_ sender: UIButton) {
        chartView.axisColor = sender.backgroundColor!
    }
}
