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
    public var chartPoints: [ChartPoint] = [] {
        didSet {
            let values = valuesFromChartPoints(chartPoints)
            let value = ceil(values.max() ?? 0.0)
            maxValue = (value != 0 ? value : 5.0)

            xLabels = labelsFromChartPoints(chartPoints)
            yPoints = pointsFromChartPoints(chartPoints)
        }
    }
    public private (set) var yPoints: [CGPoint] = []
    public private (set) var xLabels: [String]  = []

    
    // MARK: - Chart Line Attributes
    @IBInspectable public var lineWidth: CGFloat = 2 {
        didSet {
            chartLineLayer.lineWidth = lineWidth
            strokeChart(animated: false)
        }
    }
    private var lineCapStyle: CGLineCap = .round {
        didSet {
            chartLineLayer.lineCap = lineCapStyle.kCAlineCap
            strokeChart(animated: false)
        }
    }
    @IBInspectable public var lineColor: UIColor = .black {
        didSet {
            chartLineLayer.strokeColor = lineColor.cgColor
            strokeChart(animated: false)
        }
    }
    public var pointStyle: PointStyle = .none { didSet { strokeChart(animated: false) } }
    public var isCurved: Bool = false { didSet { strokeChart(animated: false) } }
    
    // MARK: - y Axis Attributes
    @IBInspectable public var yMargin: CGFloat = 30 { didSet { strokeChart(animated: false) } }
    @IBInspectable public var yLabelFontSize: CGFloat = 12.0 { didSet { strokeChart(animated: false) } }
    @IBInspectable public var yAxisOffsets: CGFloat = 20{ didSet { strokeChart(animated: false) } }
    public private (set) var maxValue: Double = 5.0
    public private (set) var minValue: Double = 0.0
    
    private var yLabelsCount: Int = 5
    private var yAxisHeight: CGFloat { return bounds.size.height - xAxisOffsets }
    private var yStepValue: Double { return (maxValue - minValue) / Double(yLabelsCount) }
    private var yStepPointValue: CGFloat { return (yAxisHeight - yMargin) / CGFloat(yLabelsCount) }

    // MARK: - x Axis Attributes
    @IBInspectable public var xMargin: CGFloat = 30 { didSet { strokeChart(animated: false) } }
    @IBInspectable public var xLabelFontSize: CGFloat = 12.0{ didSet { strokeChart(animated: false) } }
    @IBInspectable public var xAxisOffsets: CGFloat = 20 { didSet { strokeChart(animated: false) } }
    
    private var xAxisWidth: CGFloat { return bounds.size.width - yAxisOffsets }
    private var xStepPointValue: CGFloat { return (xAxisWidth - xMargin) / CGFloat(xLabels.count) }
    
    // MARK: - x & y Attributes
    @IBInspectable public var axisColor: UIColor = .black {
        didSet {
            backgroundLayer.strokeColor = axisColor.cgColor
            strokeChart(animated: false)
        }
    }
    
    private var origin: CGPoint { return CGPoint(x: yAxisOffsets, y: yAxisHeight) }
    
    // MARK: - Layer
    private let backgroundLayer: CAShapeLayer = CAShapeLayer()
    private let chartLineLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - Animation
    @IBInspectable public var animationDuration: TimeInterval = 0
    private var animated: Bool = false

    public func strokeChart(animated: Bool) {
        self.animated = animated
        setNeedsDisplay()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundLayer.strokeColor = axisColor.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.lineWidth = 1
        layer.addSublayer(backgroundLayer)
        
        chartLineLayer.fillColor = nil
        chartLineLayer.strokeColor = lineColor.cgColor
        chartLineLayer.backgroundColor = UIColor.clear.cgColor
        chartLineLayer.lineCap = lineCapStyle.kCAlineCap
        chartLineLayer.lineWidth = lineWidth
        layer.addSublayer(chartLineLayer)
    }
    
    private func animate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        if animationDuration == 0 {
            animation.duration = 0.1 * Double(xLabels.count)
        } else {
            animation.duration = animationDuration
        }
        chartLineLayer.add(animation, forKey: "ChartLineAnimation")
    }
    
    // MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        drawBackrgound()
        
        if isCurved {
            drawCurvedChartLines()
        } else {
            drawChartLines()
        }
        
        if animated { animate() }
    }
    
    private func drawChartLines() {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        
        lineColor.setStroke()
        
        if yPoints.count > 0 {
            let pointRadius = lineWidth
            
            let firstPoint = yPoints[0]
            path.move(to: firstPoint)
            drawPoint(withCenter: firstPoint, radius: pointRadius, inPath: path)
            
            for i in 1 ..< yPoints.count {
                let point = yPoints[i]
                path.addLine(to: point)
                drawPoint(withCenter: point, radius: pointRadius, inPath: path)
            }
        }
        
        chartLineLayer.path = path.cgPath
    }

    private func drawBackrgound() {
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
        for i in 0 ..< yLabelsCount {
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

extension LineChartView {
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

// Draw curved line
extension LineChartView {
    private struct CurvedControlPoint {
        var point1: CGPoint
        var point2: CGPoint
    }
    
    private func controlPointsFrom(points: [CGPoint]) -> [CurvedControlPoint] {
        var controlPoints: [CurvedControlPoint] = []
        
        let delta: CGFloat = 0.3
        for i in 1 ..< points.count {
            let prevPoint = points[i-1]
            let point = points[i]
            let controlPoint1 = CGPoint(x: prevPoint.x + delta*(point.x-prevPoint.x), y: prevPoint.y + delta*(point.y - prevPoint.y))
            let controlPoint2 = CGPoint(x: point.x - delta*(point.x-prevPoint.x), y: point.y - delta*(point.y - prevPoint.y))
            let controlPoint = CurvedControlPoint(point1: controlPoint1, point2: controlPoint2)
            controlPoints.append(controlPoint)
        }
        
        for i in 1 ..< points.count-1 {
            let p1 = controlPoints[i-1].point2
            let p2 = controlPoints[i].point1
            
            let centerPoint = points[i]
            let pp1 = CGPoint(x: 2 * centerPoint.x - p1.x, y: 2 * centerPoint.y - p1.y)
            let pp2 = CGPoint(x: 2 * centerPoint.x - p2.x, y: 2 * centerPoint.y - p2.y)
            
            controlPoints[i].point1 = CGPoint(x: (pp1.x + p2.x)/2, y: (pp1.y + p2.y)/2)
            controlPoints[i-1].point2 = CGPoint(x: (pp2.x + p1.x)/2, y: (pp2.y + p1.y)/2)
        }
        
        return controlPoints
    }
    
    private func drawCurvedChartLines() {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        
        lineColor.setStroke()
        
        if yPoints.count > 0 {
            let pointRadius = lineWidth
            
            let firstPoint = yPoints[0]
            path.move(to: firstPoint)
            drawPoint(withCenter: firstPoint, radius: pointRadius, inPath: path)
            
            
            let controlPoints = controlPointsFrom(points: yPoints)
            for i in 1 ..< yPoints.count {
                let point = yPoints[i]
                path.addCurve(to: point, controlPoint1: controlPoints[i-1].point1, controlPoint2: controlPoints[i-1].point2)
                drawPoint(withCenter: point, radius: pointRadius, inPath: path)
            }
        }
        
        chartLineLayer.path = path.cgPath
    }
}

extension LineChartView {
    private func drawText(_ text: String, inRect rect: CGRect, withFont font: UIFont, withColor color: UIColor, alignment: NSTextAlignment) {
        let paragrahStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragrahStyle.lineBreakMode = .byTruncatingTail
        paragrahStyle.alignment = alignment
        (text as NSString).draw(in: rect, withAttributes: [.paragraphStyle: paragrahStyle, .font: font, .foregroundColor: color])
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
