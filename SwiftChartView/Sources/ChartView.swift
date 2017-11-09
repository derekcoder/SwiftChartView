//
//  ChartView.swift
//  SwiftChartView
//
//  Created by ZHOU DENGFENG on 1/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import CoreGraphics

public enum PointStyle {
    case none
    case circle
    case square
    case triangle
}

public class ChartView: UIView {
    public var chartPoints: [ChartPoint] = [] {
        didSet {
            let values = valuesFromChartPoints(chartPoints)
            let value = ceil(values.max() ?? 0.0)
            self.maxValue = (value != 0 ? value : 5.0)
            
            xLabels = labelsFromChartPoints(chartPoints)
            yValues = valuesFromChartPoints(chartPoints)
        }
    }
    public internal (set) var yPoints: [CGPoint] = []
    public internal (set) var yValues: [Double] = []
    public internal (set) var xLabels: [String]  = []
    
    // MARK: - y Axis Attributes
    @IBInspectable public var yMargin: CGFloat = 30 { didSet { strokeChart(animated: false) } }
    @IBInspectable public var yLabelFontSize: CGFloat = 12.0 { didSet { strokeChart(animated: false) } }
    @IBInspectable public var yAxisOffsets: CGFloat = 20{ didSet { strokeChart(animated: false) } }
    
    // MARK: - x Axis Attributes
    @IBInspectable public var xMargin: CGFloat = 30 { didSet { strokeChart(animated: false) } }
    @IBInspectable public var xLabelFontSize: CGFloat = 12.0{ didSet { strokeChart(animated: false) } }
    @IBInspectable public var xAxisOffsets: CGFloat = 20 { didSet { strokeChart(animated: false) } }
    
    // MARK: - x & y Attributes
    @IBInspectable public var axisColor: UIColor = .black {
        didSet {
            backgroundLayer.strokeColor = axisColor.cgColor
            strokeChart(animated: false)
        }
    }
    
    var xAxisWidth: CGFloat { return bounds.size.width - yAxisOffsets }
    var yAxisHeight: CGFloat { return bounds.size.height - xAxisOffsets }
    var origin: CGPoint { return CGPoint(x: yAxisOffsets, y: yAxisHeight) }
    var xStepPointValue: CGFloat { return (xAxisWidth - xMargin) / CGFloat(xLabels.count) }
    var yLabelsCount: Int = 5
    var yStepValue: Double { return (maxValue - minValue) / Double(yLabelsCount) }
    var yStepPointValue: CGFloat { return (self.yAxisHeight - yMargin) / CGFloat(yLabelsCount) }
    public internal (set) var maxValue: Double = 5.0
    public internal (set) var minValue: Double = 0.0

    // MARK: - Layer
    let backgroundLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - Animation
    @IBInspectable public var animationDuration: TimeInterval = 0
    var animated: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        strokeChart(animated: true)
    }
    
    private func setup() {
        backgroundLayer.strokeColor = axisColor.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.lineWidth = 1
        layer.addSublayer(backgroundLayer)
    }

    public func strokeChart(animated: Bool) {
        yPoints = pointsFromChartPoints(chartPoints)
        self.animated = animated
        setNeedsDisplay()
    }
    
    func drawBackrgound() {
        let path = UIBezierPath()
        drawAxis(inPath: path)
        drawLabels(inPath: path)
        backgroundLayer.path = path.cgPath
    }
    
    private func drawAxis(inPath path: UIBezierPath) {
        path.lineWidth = 1
        
        // y
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
        for i in 0 ..< self.yLabelsCount {
            path.move(to: CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepPointValue))
            path.addLine(to: CGPoint(x: origin.x + stepLength, y: origin.y - CGFloat(i+1) * yStepPointValue))
        }
        
        // x
        for i in 0 ..< xLabels.count {
            path.move(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepPointValue, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepPointValue, y: origin.y - stepLength))
        }
    }
    
    private func drawLabels(inPath path: UIBezierPath) {
        // x
        let xLabelFont = UIFont.systemFont(ofSize: xLabelFontSize)
        for (i, label) in xLabels.enumerated() {
            let stepPoint = CGPoint(x: origin.x + CGFloat(i+1) * xStepPointValue, y: origin.y)
            let size = label.size(inFont: xLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width / 2, y: stepPoint.y + 2, width: size.width, height: size.height)
            drawText(label, inRect: rect, withFont: xLabelFont, withColor: axisColor, alignment: .center)
        }
        
        // y
        let yLabelFont = UIFont.systemFont(ofSize: yLabelFontSize)
        for i in 0 ..< yLabelsCount {
            let label = String(yStepValue * Double(i+1))
            let stepPoint = CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepPointValue)
            let size = label.size(inFont: yLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width - 2, y: stepPoint.y - size.height / 2, width: size.width, height: size.height)
            drawText(label, inRect: rect, withFont: yLabelFont, withColor: axisColor, alignment: .center)
        }
    }
}

extension ChartView {
    private func pointsFromChartPoints(_ chartPoints: [ChartPoint]) -> [CGPoint] {
        var points: [CGPoint] = []
        for i in 0 ..< chartPoints.count {
            let point = CGPoint(x: origin.x + CGFloat(i+1) * xStepPointValue, y: origin.y - CGFloat(chartPoints[i].value/yStepValue) * yStepPointValue)
            points.append(point)
        }
        return points
    }
    
    private func valuesFromChartPoints(_ chartPoints: [ChartPoint]) -> [Double] {
        return chartPoints.map { $0.value }
    }
    
    private func labelsFromChartPoints(_ chartPoints: [ChartPoint]) -> [String] {
        return chartPoints.map { $0.label }
    }
}

extension ChartView {
    private func drawText(_ text: String, inRect rect: CGRect, withFont font: UIFont, withColor color: UIColor, alignment: NSTextAlignment) {
        let paragrahStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragrahStyle.lineBreakMode = .byTruncatingTail
        paragrahStyle.alignment = alignment
        (text as NSString).draw(in: rect, withAttributes: [.paragraphStyle: paragrahStyle, .font: font, .foregroundColor: color])
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
    var kCAlineCap: String {
        switch self {
        case .butt: return kCALineCapButt
        case .round: return kCALineCapRound
        case .square: return kCALineCapSquare
        }
    }
}

