//
//  YLRecordVideoViewController.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit

open class YLRecordVideoViewController: UIViewController {
    
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    private let captureSession = AVCaptureSession()
    
    //视频输入设备
    private let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    //音频输入设备
    private let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    
    //将捕获到的视频输出到文件
    private let fileOutput = AVCaptureMovieFileOutput()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
