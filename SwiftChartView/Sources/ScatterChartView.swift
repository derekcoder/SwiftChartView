//
//  ScatterChartView.swift
//  SwiftChartView
//
//  Created by Julie on 9/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

public class ScatterChartView: ChartView {

    // MARK: - Chart Point Attributes
    @IBInspectable public var lineWidth: CGFloat = 12 {
        didSet {
            strokeChart(animated: false)
        }
    }
    @IBInspectable public var lineColor: UIColor = .black {
        didSet {
            chartPointLayer.fillColor = lineColor.cgColor
//            chartPointLayer.strokeColor = lineColor.cgColor
            strokeChart(animated: false)
        }
    }
    public var pointStyle: PointStyle = .none { didSet { strokeChart(animated: false) } }

    // MARK: - Layer
    private let chartPointLayer: CAShapeLayer = CAShapeLayer()
    private var paths: [UIBezierPath] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        chartPointLayer.fillColor = lineColor.cgColor
        chartPointLayer.strokeColor = UIColor.clear.cgColor
        chartPointLayer.backgroundColor = UIColor.clear.cgColor
//        chartBarLayer.lineCap = CA.kCAlineCap
//        chartPointLayer.lineWidth = lineWidth
        layer.addSublayer(chartPointLayer)
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
        chartPointLayer.add(animation, forKey: "ChartLineAnimation")
    }
    
    // MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        drawBackrgound()
        drawChartPoints()
        
        if animated { animate() }
    }
    
    private func drawChartPoints() {
        let path = UIBezierPath()
        
//        lineColor.setStroke()
        lineColor.setFill()
        
        if yPoints.count > 0 {
            for i in 0 ..< yPoints.count {
                let point = yPoints[i]
                path.move(to: point)
                switch pointStyle {
                case .none: fallthrough
                case .circle: drawCirclePath(withCenter: point, radius: lineWidth/2, inPath: path)
                case .square: drawSquarePath(withCenter: point, radius: lineWidth/2, inPath: path)
                case .triangle: drawTrianglePath(withCenter: point, radius: lineWidth/2, inPath: path)
                }
            }
        }
        
        chartPointLayer.path = path.cgPath
    }
    
    private func drawCirclePath(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    }
    
    private func drawSquarePath(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        path.move(to: CGPoint(x: center.x - radius, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x + radius, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x + radius, y: center.y + radius))
        path.addLine(to: CGPoint(x: center.x - radius, y: center.y + radius))
        path.addLine(to: CGPoint(x: center.x - radius, y: center.y - radius))
    }
    
    private func drawTrianglePath(withCenter center: CGPoint, radius: CGFloat, inPath path: UIBezierPath) {
        path.move(to: CGPoint(x: center.x, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x + radius, y: center.y + radius))
        path.addLine(to: CGPoint(x: center.x - radius, y: center.y + radius))
        path.addLine(to: CGPoint(x: center.x, y: center.y - radius))
    }
}
