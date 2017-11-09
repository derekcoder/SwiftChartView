//
//  BarChartView.swift
//  SwiftChartView
//
//  Created by Julie on 9/11/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

public class BarChartView: ChartView {
	
    // MARK: - Chart Line Attributes
    @IBInspectable public var lineWidth: CGFloat = 20 {
        didSet {
            chartBarLayer.lineWidth = lineWidth
            strokeChart(animated: false)
        }
    }
    private var lineCapStyle: CGLineCap = .butt {
        didSet {
            chartBarLayer.lineCap = lineCapStyle.kCAlineCap
            strokeChart(animated: false)
        }
    }
    @IBInspectable public var lineColor: UIColor = .black {
        didSet {
            chartBarLayer.strokeColor = lineColor.cgColor
            strokeChart(animated: false)
        }
    }

    // MARK: - Layer
    private let chartBarLayer: CAShapeLayer = CAShapeLayer()
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        chartBarLayer.fillColor = nil
        chartBarLayer.strokeColor = lineColor.cgColor
        chartBarLayer.backgroundColor = UIColor.clear.cgColor
        chartBarLayer.lineCap = lineCapStyle.kCAlineCap
        chartBarLayer.lineWidth = lineWidth
        layer.addSublayer(chartBarLayer)
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
        chartBarLayer.add(animation, forKey: "ChartLineAnimation")
    }

    // MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        drawBackrgound()
        drawChartBars()
        
        if animated { animate() }
    }
    
    private func drawChartBars() {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        
        lineColor.setStroke()
        
        if yPoints.count > 0 {
            for i in 0 ..< yPoints.count {
                let point = yPoints[i]
                let startPoint = CGPoint(x: point.x, y: origin.y)
                let endPoint = point
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
        }
        
        chartBarLayer.path = path.cgPath
    }
}
