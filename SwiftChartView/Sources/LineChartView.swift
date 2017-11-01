//
//  LineChartView.swift
//  SwiftChartView
//
//  Created by ZHOU DENGFENG on 1/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
public class LineChartView: ChartView {
    public var xLabels: [String] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var yDatas: [Double] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var yLabels: [String]? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var xAxisOffsets: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var yAxisOffsets: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var axisColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        drawAxis()
    }
    
    private func drawAxis() {
        let xAxisWidth = bounds.size.width
        let yAxisHeight = bounds.size.height
        
        let arrowWidth: CGFloat = 6
        let arrowHeight: CGFloat = 6
        let arrowHalfWidth: CGFloat = arrowWidth / 2
        
        // Draw y axis
        let path = UIBezierPath()
        path.move(to: CGPoint(x: yAxisOffsets, y: yAxisHeight - xAxisOffsets))
        path.addLine(to: CGPoint(x: yAxisOffsets, y: 0))
        
        // y axis arrow
        path.move(to: CGPoint(x: yAxisOffsets - arrowHalfWidth, y: arrowHeight))
        path.addLine(to: CGPoint(x: yAxisOffsets, y: 0))
        path.addLine(to: CGPoint(x: yAxisOffsets + arrowHalfWidth, y: arrowHeight))

        // Draw x axis
        path.move(to: CGPoint(x: yAxisOffsets, y: yAxisHeight - xAxisOffsets))
        path.addLine(to: CGPoint(x: xAxisWidth, y: yAxisHeight - xAxisOffsets))
        
        // y axis arrow
        path.move(to: CGPoint(x: xAxisWidth - arrowHeight, y: yAxisHeight - xAxisOffsets - arrowHalfWidth))
        path.addLine(to: CGPoint(x: xAxisWidth, y: yAxisHeight - xAxisOffsets))
        path.addLine(to: CGPoint(x: xAxisWidth - arrowHeight, y: yAxisHeight - xAxisOffsets + arrowHalfWidth))

        axisColor.setStroke()
        
        path.stroke()
    }
}




































