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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        chartView.drawChart()
    }
}

