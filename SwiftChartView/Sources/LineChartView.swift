//
//  LineChartView.swift
//  SwiftChartView
//
//  Created by ZHOU DENGFENG on 1/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import QuartzCore

public enum PointStyle {
    case none
    case circle
}

@IBDesignable
public class LineChartView: ChartView {
    public var xLabels: [String] =  []
    public var yDatas: [Double] = []
    
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
    
    // MARK: - Line Attributes
    @IBInspectable
    public var lineWidth: CGFloat = 3
    public var lineCapStyle: CGLineCap = .round
    @IBInspectable
    public var lineColor: UIColor = .lightGray
    
    public var pointStyle: PointStyle = .none
    
    // MARK: - y Axis Attributes
    private var maxData: Double { return ceil(yDatas.max() ?? 0.0) }
    private var minData: Double { return 0.0 }
    private var yLabelsCount: Int = 5
    private var yStepData: Double { return (maxData - minData) / Double(yLabelsCount) }
    
    // MARK: - Draw
    private var xLabelsCount: Int { return xLabels.count }
    private var xAxisWidth: CGFloat { return bounds.size.width - yAxisOffsets }
    private var yAxisHeight: CGFloat { return bounds.size.height - xAxisOffsets }
    private var origin: CGPoint { return CGPoint(x: yAxisOffsets, y: yAxisHeight) }
    private var xStepLength: CGFloat { return (xAxisWidth - xMargin) / CGFloat(xLabelsCount) }
    private var yStepLength: CGFloat { return (yAxisHeight - yMargin) / CGFloat(yLabelsCount) }
    
    public override func draw(_ rect: CGRect) {
        drawAxis()
        drawLabels()
        drawDatas()
//        drawChartLine().stroke()
    }
    
    public func strokeChart() {
        setNeedsDisplay()
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
            let label = String(yStepData * Double(i+1))
            let stepPoint = CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepLength)
            let size = label.size(inFont: yLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width - 2, y: stepPoint.y - size.height / 2, width: size.width, height: size.height)
            drawText(label, in: rect, with: yLabelFont, alignment: .center)
        }
    }
    
    private var chartLineLayer: CAShapeLayer!
    private func drawDatas() {
        let chartLinePath = drawChartLine()

        if chartLineLayer != nil {
            chartLineLayer.removeFromSuperlayer()
            chartLineLayer = nil
        }

        chartLineLayer = CAShapeLayer()
        chartLineLayer.path = chartLinePath.cgPath
        chartLineLayer.strokeEnd = 1
        chartLineLayer.fillColor = UIColor.clear.cgColor
        chartLineLayer.strokeColor = lineColor.cgColor
        chartLineLayer.lineWidth = lineWidth
        chartLineLayer.lineCap = lineCapStyle.kCAlineCap
        layer.addSublayer(chartLineLayer)
    }
    
    private func animate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        chartLineLayer.add(animation, forKey: "ChartLineAnimation")
        
        chartLineLayer.strokeEnd = 1
    }
    
    private func drawChartLine() -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        
        lineColor.setStroke()
        
        guard yDatas.count > 0 else { return path }
        
        let pointRadius = lineWidth
        
        let firstData = yDatas[0]
        let firstPoint = CGPoint(x: origin.x + CGFloat(1) * xStepLength, y: origin.y - CGFloat(firstData/yStepData) * yStepLength)
        
        path.move(to: firstPoint)
        drawPoint(withCenter: firstPoint, radius: pointRadius, inPath: path)

        for i in 1 ..< yDatas.count {
            let point = CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y - CGFloat(yDatas[i]/yStepData) * yStepLength)
            path.addLine(to: point)
            drawPoint(withCenter: point, radius: pointRadius, inPath: path)
        }
        
        return path
    }
}

extension LineChartView {
    private func yAxisInfo() -> (minData: Double, maxData: Double, labelsCount: Int) {
        let minD = (self.minData > 0) ? self.minData : 0.0
        let maxD = max(minD, self.maxData)
        let count = Int(maxD)
        return (minD, maxD, count)
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

// Draw point
extension LineChartView {
    private func drawPoint(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        switch pointStyle {
        case .none: break
        case .circle: drawCircle(withCenter: center, radius: radius, inPath: path)
        }
        path.move(to: center)
    }
    
    private func drawCircle(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    }
}

extension String {
    func size(inFont font: UIFont) -> CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return rect.size
    }
}

extension CGLineCap {
    public var kCAlineCap: String {
        switch self {
        case .butt: return kCALineCapButt
        case .round: return kCALineCapRound
        case .square: return kCALineCapSquare
        }
    }
}

































