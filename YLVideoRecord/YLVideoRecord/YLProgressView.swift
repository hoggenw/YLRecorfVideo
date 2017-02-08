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
    //进度条计时器时间间隔
    var incInterval: TimeInterval = 0.05
    //总的时间
    var totalTimerInterval: TimeInterval?
    //总时间标准
    var totalTime: TimeInterval?
    
    var showProgress: CGFloat?
    //进度开始标刻
    var startProgress: CGFloat?
    var timeLeftLabel = UILabel()
    
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
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftLabel.frame = CGRect(x: 0, y: shapeLayer.lineWidth, width: frame.width, height: frame.height - shapeLayer.lineWidth)
        timeLeftLabel.textAlignment = .center
        timeLeftLabel.textColor = UIColor.white
        timeLeftLabel.adjustsFontSizeToFitWidth = true
        tintColorDidChange()
        self.layer.addSublayer(self.shapeLayer)
        self.addSubview(timeLeftLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Color
    override open func tintColorDidChange() {
        if (self.superclass?.instancesRespond(to: #selector(tintColorDidChange)))! {
            super.tintColorDidChange()
        }
        
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.borderColor = UIColor.green.cgColor
    }
    
    ///
    ///
    /// - Parameter progress: 输入进度条开始比例，不大于1
    open func startProgress(progress: CGFloat ,totalTimer: TimeInterval) {
        showProgress = progress
        startProgress = progress
        totalTimerInterval = totalTimer
        totalTime = totalTimer
        timeLeftLabel.text = String(format: "%.0lf″00", totalTimer)
        progressTimer = Timer(timeInterval: incInterval, target: self, selector: #selector(timerProgress), userInfo: nil, repeats:true)
        RunLoop.current.add(progressTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        
        
    }
    
    func timerProgress() {

        totalTimerInterval = totalTimerInterval! - incInterval
        showProgress = showProgress! - startProgress! * CGFloat(incInterval / totalTime!)
        let second =  Int(totalTimerInterval! * 100 / 100)
        let microsecond = Int(totalTimerInterval! * 100) % 100
        timeLeftLabel.text = String(format: "%d″%2d", second,microsecond)
        update(progress: showProgress!)
        if totalTimerInterval! < 0 {
            if progressTimer != nil {
                progressTimer?.invalidate()
                progressTimer = nil
                print("over")
                timeLeftLabel.text = ""
                postNotification()
            }
        }
        
    }
    
    open func stopProgress() {
        if progressTimer != nil {
            progressTimer?.invalidate()
            progressTimer = nil
            print("over")
            timeLeftLabel.text = ""
            update(progress: 0)
        }
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
        shapeLayer.strokeEnd = 1 - (1 - progress)/2
        shapeLayer.strokeStart = 1 - shapeLayer.strokeEnd
        CATransaction.commit()
        
    }
    func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "YLProgressTimeOver"), object: nil)
    }
    
    func shapeLayerPath() -> UIBezierPath {
        
        let width = self.frame.size.width;
        let borderWidth = self.shapeLayer.borderWidth;
        
        let path = UIBezierPath()
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        path.move(to: CGPoint(x: 0, y: -2))
        path.addLine(to: CGPoint(x: width, y: -2))
        return path;
    }

}
















