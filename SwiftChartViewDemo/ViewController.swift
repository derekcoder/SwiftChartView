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
    private lazy var chartPoints: [ChartPoint] = {
        var chartPoints: [ChartPoint] = []
        for i in 1 ... 7 {
            let value = Double(arc4random_uniform(100)) + 30
            let chartPoint = ChartPoint(label: "11-0\(i)", value: value)
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
    
    @IBAction func isCurvedChanged(_ sender: UISwitch) {
        chartView.isCurved = sender.isOn
    }
    
    @IBAction func lineWidthChanged(_ sender: UISlider) {
        chartView.lineWidth = CGFloat(sender.value)
    }
    
    @IBAction func pointStyleChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            chartView.pointStyle = .none
        } else if sender.selectedSegmentIndex == 1 {
            chartView.pointStyle = .circle
        }
    }
    
    @IBAction func tapLineColorButton(_ sender: UIButton) {
        chartView.lineColor = sender.backgroundColor!
    }
    
    @IBAction func tapAxisColorButton(_ sender: UIButton) {
        chartView.axisColor = sender.backgroundColor!
    }
}

