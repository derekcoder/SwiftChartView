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
    public var xLabels: [String] = ["Jan", "Feb", "Mar"] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var yDatas: [Double] = [1.0, 2.0, 3.0] {
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
        
        let origin = CGPoint(x: yAxisOffsets, y: yAxisHeight - xAxisOffsets)
        
        // draw y axis line
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: CGPoint(x: yAxisOffsets, y: 0))
        
        // draw y axis arrow
        path.move(to: CGPoint(x: yAxisOffsets - arrowHalfWidth, y: arrowHeight))
        path.addLine(to: CGPoint(x: yAxisOffsets, y: 0))
        path.addLine(to: CGPoint(x: yAxisOffsets + arrowHalfWidth, y: arrowHeight))

        // draw x axis line
        path.move(to: origin)
        path.addLine(to: CGPoint(x: xAxisWidth, y: yAxisHeight - xAxisOffsets))
        
        // draw x axis arrow
        path.move(to: CGPoint(x: xAxisWidth - arrowHeight, y: yAxisHeight - xAxisOffsets - arrowHalfWidth))
        path.addLine(to: CGPoint(x: xAxisWidth, y: yAxisHeight - xAxisOffsets))
        path.addLine(to: CGPoint(x: xAxisWidth - arrowHeight, y: yAxisHeight - xAxisOffsets + arrowHalfWidth))
        
        // draw y axis seperator
        let yCount = yDatas.count
        let yStepHeight = yAxisHeight / CGFloat(yCount)

        for i in 0 ..< yCount {
            path.move(to: CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepHeight))
            path.addLine(to: CGPoint(x: origin.x + 2, y: origin.y - CGFloat(i+1) * yStepHeight))
        }
        
        // draw x axis seperator
        let xCount = xLabels.count
        let xStepWidth = xAxisWidth / CGFloat(xCount)
        
        for i in 0 ..< xCount {
            path.move(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepWidth, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepWidth, y: origin.y - 2))
        }
        
        axisColor.setStroke()
        
        path.stroke()
    }
}




































