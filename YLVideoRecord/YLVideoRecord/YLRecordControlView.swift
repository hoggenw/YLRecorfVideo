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
    open var progressViewHeight: CGFloat! {
     
        didSet {
            if progressView != nil {
                progressView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: progressViewHeight)
            }
        }
    }
    open var borderWidth: CGFloat! {
        didSet {
            progressView.shapeLayer.borderWidth = borderWidth
        }
    }
    open var lineWidth: CGFloat! {
        didSet {
            progressView.shapeLayer.lineWidth = lineWidth
        }
    }
    var progress: CGFloat! {
        didSet {
            set(progress: progress)
        }
    }

    
    fileprivate var countTimer:Timer!
    fileprivate let progressViewAnimationKey: String = "YLprogressViewAnimationKey"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialUI()
        initialDataSource()
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialUI() {
        progressViewHeight = 2
        progressView = YLProgressView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 2))
        borderWidth = 1
        lineWidth = 2
        progress = 1.0
        
    }
    
    func initialDataSource() {
        
        
    }
    //MARK: - Progress Control
    func set(progress: CGFloat, animated: Bool) {
        progressView.update(progress: self.progress)
    }
    
    func set(progress: CGFloat) {
        set(progress: progress, animated: false)
    }
    

    

}
