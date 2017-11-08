//
//  ChartPoint.swift
//  SwiftChartView
//
//  Created by ZHOU DENGFENG on 8/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import Foundation

public struct ChartPoint {
    public let label: String
    public let value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
}
