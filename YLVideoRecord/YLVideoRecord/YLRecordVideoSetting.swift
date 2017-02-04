//
//  YLRecordVideoSetting.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit

open class YLRecordVideoSetting: NSObject {
    //MARK: - Public Property
    //最大允许的录制时间（秒）
    open var totalSeconds: Float64 = 15.00
    
    //每秒帧数
    open var framesPerSecond: Int32 = 30
    
    //进度条计时器时间间隔
    open var incInterval: TimeInterval = 0.05
    
    //输出尺寸
    open var renderSize: CGSize = CGSize(width: 480, height: 640)
    
    //输出文件格式
    open var videoType: String = AVFileTypeMPEG4
    
    //设置图像源尺寸
    open var sessionPreset: String = AVCaptureSessionPreset640x480
    
    //设置全局色
    open var tintColor: UIColor = UIColor.white
    
    //允许视频片段拼接
    open var allowBurst: Bool = false
    

}
