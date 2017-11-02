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
            drawChart()
        }
    }
    public var yDatas: [Double] = [1.0, 2.0, 5.0]
    public var yLabels: [String]? = nil
    
    public var xMargin: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var yMargin: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var xAxisOffsets: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var yAxisOffsets: CGFloat = 20 {
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
    
    // MARK: - Draw
    private var xLabelsCount: Int { return xLabels.count }
    private var yLabelsCount: Int { return Int(yDatas.max() ?? 0.0) }
    private var xAxisWidth: CGFloat { return bounds.size.width - yAxisOffsets }
    private var yAxisHeight: CGFloat { return bounds.size.height - xAxisOffsets }
    private var origin: CGPoint { return CGPoint(x: yAxisOffsets, y: yAxisHeight) }
    private var xStepLength: CGFloat { return (xAxisWidth - xMargin) / CGFloat(xLabelsCount) }
    private var yStepLength: CGFloat { return (yAxisHeight - yMargin) / CGFloat(yLabelsCount) }
    
    public override func draw(_ rect: CGRect) {
        drawAxis()
        drawChart()
    }
    
    private func drawAxis() {
        // y
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: CGPoint(x: yAxisOffsets, y: 0))
        
        // x
        path.move(to: origin)
        path.addLine(to: CGPoint(x: xAxisWidth + yAxisOffsets, y: yAxisHeight))

        // Draw axis arrow
        let arrowWidth: CGFloat = 6
        let arrowHeight: CGFloat = 6
        let arrowHalfWidth: CGFloat = arrowWidth / 2

        // y
        path.move(to: CGPoint(x: yAxisOffsets - arrowHalfWidth, y: arrowHeight))
        path.addLine(to: CGPoint(x: yAxisOffsets, y: 0))
        path.addLine(to: CGPoint(x: yAxisOffsets + arrowHalfWidth, y: arrowHeight))

        // x
        path.move(to: CGPoint(x: xAxisWidth + yAxisOffsets - arrowHeight, y: yAxisHeight - arrowHalfWidth))
        path.addLine(to: CGPoint(x: xAxisWidth + yAxisOffsets, y: yAxisHeight))
        path.addLine(to: CGPoint(x: xAxisWidth + yAxisOffsets - arrowHeight, y: yAxisHeight + arrowHalfWidth))

        // Draw step
        let stepLength: CGFloat = 2

        // y
        for i in 0 ..< yLabelsCount {
            path.move(to: CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepLength))
            path.addLine(to: CGPoint(x: origin.x + stepLength, y: origin.y - CGFloat(i+1) * yStepLength))
        }
        
        // x
        for i in 0 ..< xLabelsCount {
            path.move(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y - stepLength))
        }
        
        axisColor.setStroke()
        
        path.stroke()
    }
    
    public func drawChart() {
        setNeedsDisplay()
        
        // Draw labels
        drawLabels()
        
        // Draw datas
        drawDatas()
    }
    
    private func drawLabels() {
        // x
        let xLabelFont = UIFont.systemFont(ofSize: 12.0)
        for (i, label) in xLabels.enumerated() {
            let stepPoint = CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y)
            let size = label.size(inFont: xLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width / 2, y: stepPoint.y + 2, width: size.width, height: size.height)
            drawText(label, in: rect, with: xLabelFont, alignment: .center)
        }
        
        // y
        let yLabelFont = UIFont.systemFont(ofSize: 12.0)
        for i in 0 ..< yLabelsCount {
            let label = "\(Double(i+1))"
            let stepPoint = CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepLength)
            let size = label.size(inFont: yLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width - 2, y: stepPoint.y - size.height / 2, width: size.width, height: size.height)
            drawText(label, in: rect, with: yLabelFont, alignment: .center)
        }
    }
    
    private var chartLineLayer: CAShapeLayer!
    private var chartPointLayer: CAShapeLayer!
    private func drawDatas() {
        let chartLinePath = drawChartLine()
        chartLinePath.stroke()
    }
    
    private func drawChartLine() -> UIBezierPath {
        let path = UIBezierPath()
        
        guard yDatas.count > 0 else { return path }
        
        let firstData = yDatas[0]
        let firstPoint = CGPoint(x: origin.x + CGFloat(1) * xStepLength, y: origin.y - CGFloat(firstData) * yStepLength)
        path.move(to: firstPoint)
        
        for i in 1 ..< yDatas.count {
            let point = CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y - CGFloat(yDatas[i]) * yStepLength)
            path.addLine(to: point)
        }
        
        return path
    }
}

extension LineChartView {
    private func drawText(_ text: String, in rect: CGRect, with font: UIFont, alignment: NSTextAlignment) {
        let paragrahStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragrahStyle.lineBreakMode = .byTruncatingTail
        paragrahStyle.alignment = alignment
        (text as NSString).draw(in: rect, withAttributes: [.paragraphStyle: paragrahStyle, .font: font])
    }
}

extension String {
    func size(inFont font: UIFont) -> CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return rect.size
    }
}



































