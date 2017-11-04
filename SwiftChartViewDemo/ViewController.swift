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
        
        chartView.xLabels = ["2017/11/01", "2017/11/02", "2017/11/03", "2017/11/04", "2017/11/05", "2017/11/06", "2017/11/07"]
        chartView.yDatas = [0.0, 0.0, 325.0, 25.0, 0.0, 0.0, 75.0]
    }
}

