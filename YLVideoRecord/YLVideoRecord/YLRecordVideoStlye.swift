//
//  YLRecordVideoStlye.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public enum AVCameraStatues {
    case success
    case unAuthorized
    case failed
}
public enum YLVideoQuality {
    case normalQuality
    case lowQuality
    case highQuality
}

public protocol YLRecordVideoControlDelegate {
    func startRecordDelegate()
    func restartRecordDelegate()
    func cancelRecordDelegate()
    func stopRecordDelegate()
    func choiceVideoDelegate()
}



