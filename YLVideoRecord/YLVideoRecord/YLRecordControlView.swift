//
//  YLRecordControlView.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/4.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

open class YLRecordControlView: UIView {
    open var progressView: YLProgressView!

    
    /// 录制的控制代理
    open var delegate: YLRecordVideoControlDelegate?
    
    fileprivate var recordButton = UIButton()
    fileprivate var stopOrChioceButton = UIButton()
    fileprivate var cancalButton = UIButton()
    
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
        let progressView = YLProgressView(frame: CGRect(x: 0, y: 100, width: frame.size.width, height: 20))
        self.addSubview(progressView)
        
        recordButton.frame = CGRect(x: frame.width/2 - 30, y: (frame.height - 20)/2 - 30, width: 60, height: 60)
        self.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(recordButtonAction(sender:)), for: .touchUpInside)
        
        progressView.startProgress(progress: 1, totalTimer: 10)
        
        
    }
    
    func recordButtonAction(sender:UIButton) {
//        let status = sender.isSelected
//        sender.isSelected = !sender.isSelected
        
    }


    

}
