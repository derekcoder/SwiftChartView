//
//  LineChartView.swift
//  SwiftChartView
//
//  Created by ZHOU DENGFENG on 1/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

@IBDesignable
public class LineChartView: ChartView {
    
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
    
    // MARK: - Layer
    private let chartLineLayer: CAShapeLayer = CAShapeLayer()
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
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
        if self.animationDuration == 0 {
            animation.duration = 0.15 * Double(xLabels.count)
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

// Draw point
extension LineChartView {
    private func drawPoint(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        switch pointStyle {
        case .none: break
        case .circle: drawCircle(withCenter: center, radius: radius, inPath: path)
        case .square: break
        case .triangle: break
        }
        path.move(to: center)
    }
    
    private func drawCircle(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    }
}

