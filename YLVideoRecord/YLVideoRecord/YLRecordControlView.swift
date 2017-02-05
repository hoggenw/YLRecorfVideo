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
    /// - Parameter frame: 控制视图的size建议最少大于120
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialUI()

    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialUI() {
        progressView = YLProgressView(frame: CGRect(x: 0, y: 100, width: frame.size.width, height: 20))
        self.addSubview(progressView)
        
        recordButton.frame = CGRect(x: frame.width/2 - 30, y: (frame.height - 20)/2 - 30, width: 60, height: 60)
        self.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(recordButtonAction(sender:)), for: .touchUpInside)
        
        stopOrChioceButton.frame = CGRect(x: frame.width - 60, y: (frame.height - 20)/2 - 30, width: 50, height: 40)
        self.addSubview(stopOrChioceButton)
        stopOrChioceButton.addTarget(self, action: #selector(stopOrChioceButtonAction(sender:)), for: .touchUpInside)
        
        cancalButton.frame = CGRect(x: 10, y: (frame.height - 20)/2 - 30, width: 50, height: 40)
        self.addSubview(cancalButton)
        cancalButton.addTarget(self, action: #selector(cancalButtonAction(sender:)), for: .touchUpInside)

        
        progressView.startProgress(progress: 1, totalTimer: 10)
        
        
    }
    
    func recordButtonAction(sender:UIButton) {
//        let status = sender.isSelected
//        sender.isSelected = !sender.isSelected
        
    }
    
    func stopOrChioceButtonAction(sender:UIButton) {
        
    }
    
    func cancalButtonAction(sender: UIButton) {
        
    }


    

}
