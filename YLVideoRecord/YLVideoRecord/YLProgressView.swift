//
//  YLProgressView.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

open class YLProgressView: UIView {

    
    var shapeLayer :CAShapeLayer!
    public var progressTimer: Timer?
    
    deinit {
        if progressTimer != nil {
            progressTimer?.invalidate()
            progressTimer = nil
        }
        print("progress deinit")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.borderWidth = 1
        shapeLayer.lineWidth = 2
        self.layer.addSublayer(self.shapeLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func startProgress(progress: CGFloat) {
        
    }
    
    open func stopProgress() {
        
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.cornerRadius = frame.size.width / 2.0

        shapeLayer.path = shapeLayerPath().cgPath
    }
    
    open func update(progress: CGFloat) {
        CATransaction.begin()
        //显式事务默认开启动画效果,kCFBooleanTrue关闭
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        shapeLayer.strokeEnd = progress
        shapeLayer.strokeStart = 1 - progress
        CATransaction.commit()
        
    }
    
    func shapeLayerPath() -> UIBezierPath {
        
        let width = self.frame.size.width;
        let borderWidth = self.shapeLayer.borderWidth;
        
        let path = UIBezierPath()
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        return path;
    }

}
















