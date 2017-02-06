//
//  YLRecordControlView.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/4.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

open class YLRecordControlView: UIView {


    
    /// 录制的控制代理
    open var delegate: YLRecordVideoControlDelegate?
    
    fileprivate var recordButton = UIButton()
    fileprivate var stopOrChioceButton = UIButton()
    fileprivate var cancalButton = UIButton()
    //持有进度条
    open var progressView: YLProgressView!
    ///
    ///
    /// - Parameter frame: 控制视图的size建议最少大于100
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        initialUI()

    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialUI() {
        progressView = YLProgressView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 20))
        self.addSubview(progressView)
        
        recordButton.frame = CGRect(x: frame.width/2 - 30, y: 20 + (frame.height - 20)/2 - 35, width: 60, height: 60)
        recordButton.layer.cornerRadius = 30
        recordButton.setTitle("开始", for: .normal)
        recordButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.clipsToBounds = true
        recordButton.backgroundColor = UIColor.orange
        self.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(recordButtonAction(sender:)), for: .touchUpInside)
        
        stopOrChioceButton.frame = CGRect(x: frame.width - 60, y: 20 + (frame.height - 20)/2 - 25, width: 50, height: 40)
        self.addSubview(stopOrChioceButton)
        stopOrChioceButton.setTitleColor(UIColor.white, for: .normal)
        stopOrChioceButton.setTitle("停止", for: .normal)
        stopOrChioceButton.addTarget(self, action: #selector(stopOrChioceButtonAction(sender:)), for: .touchUpInside)
        
        cancalButton.frame = CGRect(x: 10, y: 20 + (frame.height - 20)/2 - 25, width: 50, height: 40)
        self.addSubview(cancalButton)
        cancalButton.setTitleColor(UIColor.white, for: .normal)
        cancalButton.setTitle("取消", for: .normal)
        cancalButton.addTarget(self, action: #selector(cancalButtonAction(sender:)), for: .touchUpInside)

        
    }
    
    func recordButtonAction(sender:UIButton) {
        progressView.startProgress(progress: 1, totalTimer: 10)

        
    }
    
    func stopOrChioceButtonAction(sender:UIButton) {
        progressView.stopProgress()
        
    }
    
    func cancalButtonAction(sender: UIButton) {
        
    }


    

}
