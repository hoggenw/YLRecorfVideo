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
        progressView.startProgress(progress: 1, totalTimer: 10)
        
    }


    

}
