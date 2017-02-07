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
    
    //最大允许的录制时间（秒）
    var totalSeconds: Float64 = 10.00
    
    //每秒帧数
    var framesPerSecond: Int32 = 30
    //设置图像源尺寸
    var sessionPreset: String = AVCaptureSessionPreset640x480
    //输出文件格式
    var videoType: String = AVFileTypeMPEG4
    //
    private var setupResult: AVCameraStatues!
    //
    private let sessionQueue = DispatchQueue.init(label: "VideoCaptureQueue")
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    private let captureSession = AVCaptureSession()
    
    //视频输入设备
    private let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    //音频输入设备
    private let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    
    //将捕获到的视频输出到文件
    private let fileOutput = AVCaptureMovieFileOutput()
    
    fileprivate var customVideoPath: String = YLRecordVideoViewController.recordVideoPath()
    
    weak var videoLayer: AVCaptureVideoPreviewLayer!
    weak var playerLayer:AVPlayerLayer!

    //MARK: - Life Cycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        initUI()
        setupCaptureSession()
    }

    func initUI() {
        
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoLayer.pointForCaptureDevicePoint(ofInterest: CGPoint(x: 0, y: 0))
        view.layer.addSublayer(videoLayer)
        
        
        let recordView =  YLRecordControlView(frame: CGRect(x: 0, y: self.view.bounds.size.height - 100, width: self.view.bounds.size.width, height: 100))
        recordView.totalSeconds = totalSeconds
        self.view.addSubview(recordView)
        
        
        
        
    }
    
    func setupCaptureSession () {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            setupResult = .success
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self] (success) in
                if !success {
                    self?.setupResult = .unAuthorized
                }
                self?.sessionQueue.resume()
            })
            
        
        default:
            setupResult = .unAuthorized
        }
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset
        //添加视频、音频输入设备
        let  videoInput = try! AVCaptureDeviceInput(device: videoDevice)
        captureSession.addInput(videoInput)
        //添加视频捕获输出
        let maxDuration = CMTimeMakeWithSeconds(totalSeconds, framesPerSecond)
        fileOutput.maxRecordedDuration = maxDuration
        captureSession.addOutput(fileOutput)
        captureSession.sessionPreset = sessionPreset
        captureSession.commitConfiguration()
        
    }
    
    private final func setupAssetWriter() {
        sessionQueue.async {[weak self] in
            guard let result = self?.setupResult else {
                return
            }
            switch result {
            case .success:
                self?.captureSession.startRunning()
                var assetWriter: AVAssetWriter
                do {
                    assetWriter = try AVAssetWriter(outputURL: URL(fileURLWithPath:(self?.customVideoPath)!), fileType: (self?.videoType)!)
                }catch {
                    return
                }

            case .unAuthorized:
                return
            case .failed :
                print("sda")
            }
            
        }
        
    }
    
    
    
    //MARK: static method
    static func recordVideoPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let name = randomUpperCaseString(length: 32)
        let destinationPath = String(format: "%@/%@.mp4", documentsPath,name)
        return destinationPath
    }
    
    static func randomUpperCaseString(length: Int ) -> String {
        var returnString = ""
        for _ in 0..<length {
            let randomNumber = arc4random_uniform(26) + 65
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            returnString.append(randomChar)
        }
        return returnString
    }
    
    
    
    
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}












