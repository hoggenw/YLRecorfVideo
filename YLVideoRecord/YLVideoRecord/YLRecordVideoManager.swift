//
//  YLRecordVideoManager.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public class YLRecordVideoManager: NSObject {
    
    public var videoQuality: YLVideoQuality = .normalQuality
    //设置录制总时间 默认10秒
    public var recordTotalTime: Float64 = 10

    public static let recordVideoManager = YLRecordVideoManager()
    private var recordViewController = YLRecordVideoViewController()
    public var delegate: YLRecordVideoChoiceDelegate?
    
    override init() {
        super.init()
        videoQuality = .normalQuality
    }
    
    public class func shareManager() -> YLRecordVideoManager {
        return recordVideoManager;
    }
    
    //显示录制界面
    public func showRecordView(viewController: UIViewController) {
        recordViewController.videoQuality = videoQuality
        recordViewController.totalSeconds = recordTotalTime
        recordViewController.delegate = self
        viewController.navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    //MARK: 删除录制视频
    public class func deleteFile(path: String)  {
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
                print("删除已存在视频")
            } catch _ {
                print("删除已存在视频失败")
            }
            print("delete video file: \(path)")
        }
    }
}

extension YLRecordVideoManager: YLRecordVideoChoiceDelegate {
    public func choiceVideoWith(path: String) {
        if delegate != nil {
            delegate?.choiceVideoWith(path: path)
        }
    }
}
