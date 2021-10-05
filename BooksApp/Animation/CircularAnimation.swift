//
//  CircularAnimation.swift
//  BooksApp
//
//  Created by Кирилл Заборский on 04.10.2021.
//

import UIKit

class CircularProgressView: UIView {

    private var circleLayerOut = CAShapeLayer()
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 100, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayerOut.path = circularPath.cgPath
        circleLayerOut.fillColor = UIColor.clear.cgColor
        circleLayerOut.lineCap = .round
        circleLayerOut.lineWidth = 24.0
        circleLayerOut.strokeColor = UIColor.blue.cgColor
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeColor = #colorLiteral(red: 0.3882352941, green: 0.5843137255, blue: 1, alpha: 1)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 18.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(circleLayerOut)
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
