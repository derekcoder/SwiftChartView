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
//    public var xLabels: [String] = ["2017/11/01", "2017/11/02", "2017/11/03", "2017/11/04", "2017/11/05", "2017/11/06", "2017/11/07"]
//    public var yDatas: [Double] = [0.0, 0.0, 325.0, 25.0, 0.0, 0.0, 75.0]
    public var xLabels: [String] = []
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
    public var axisColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Line Attributes
    @IBInspectable
    public var lineWidth: CGFloat = 2
    public var lineCapStyle: CGLineCap = .round
    @IBInspectable
    public var lineColor: UIColor = .lightGray
    
    public var pointStyle: PointStyle = .none
    
    @IBInspectable
    public var xLabelFontSize: CGFloat = 12.0
    @IBInspectable
    public var yLabelFontSize: CGFloat = 12.0

    // MARK: - y Axis Attributes
    private var maxData: Double {
        let data = ceil(yDatas.max() ?? 0.0)
        return data != 0 ? data : 5.0
    }
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
    
    public func strokeChart() {
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundLayer = CAShapeLayer()
        backgroundLayer.strokeColor = axisColor.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.lineWidth = 1
        layer.addSublayer(backgroundLayer)
        
        chartLineLayer = CAShapeLayer()
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
        animation.duration = 1.0
        chartLineLayer.add(animation, forKey: "ChartLineAnimation")
    }
    
    private var backgroundLayer: CAShapeLayer!
    private var chartLineLayer: CAShapeLayer!

    // MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        drawBackrgound()
        drawChartLines()
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
            path.move(to: CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepLength))
            path.addLine(to: CGPoint(x: origin.x + stepLength, y: origin.y - CGFloat(i+1) * yStepLength))
        }
        
        // x
        for i in 0 ..< xLabelsCount {
            path.move(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y - stepLength))
        }
    }
    
    private func drawLabels(inPath path: UIBezierPath) {
        // x
        let xLabelFont = UIFont.systemFont(ofSize: xLabelFontSize)
        for (i, label) in xLabels.enumerated() {
            let stepPoint = CGPoint(x: origin.x + CGFloat(i+1) * xStepLength, y: origin.y)
            let size = label.size(inFont: xLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width / 2, y: stepPoint.y + 2, width: size.width, height: size.height)
            drawText(label, inRect: rect, withFont: xLabelFont, withColor: axisColor, alignment: .center)
        }
        
        // y
        let yLabelFont = UIFont.systemFont(ofSize: yLabelFontSize)
        for i in 0 ..< yLabelsCount {
            let label = String(yStepData * Double(i+1))
            let stepPoint = CGPoint(x: origin.x, y: origin.y - CGFloat(i+1) * yStepLength)
            let size = label.size(inFont: yLabelFont)
            let rect = CGRect(x: stepPoint.x - size.width - 2, y: stepPoint.y - size.height / 2, width: size.width, height: size.height)
            drawText(label, inRect: rect, withFont: yLabelFont, withColor: axisColor, alignment: .center)
        }
    }
    
    @IBInspectable
    public var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    private func drawChartLines() {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        
        lineColor.setStroke()
        
        if yDatas.count > 0 {
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
        }
        
        chartLineLayer.path = path.cgPath
        
        animate()
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

































