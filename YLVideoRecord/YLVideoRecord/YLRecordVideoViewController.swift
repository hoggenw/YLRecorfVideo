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
    
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    
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
    fileprivate var previewButton: UIButton!
    
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
        setupAssetWriter()
    }

    func initUI() {
        
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoLayer.pointForCaptureDevicePoint(ofInterest: CGPoint(x: 0, y: 0))
        view.layer.addSublayer(videoLayer)
        
        playerLayer = AVPlayerLayer()
        playerLayer.frame = CGRect(x: 0, y: 100, width: ScreenWidth, height: ScreenHeight - 200)
        playerLayer.isHidden = true
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //NotificationCenter.default.addObserver(self, selector: #selector(videoPlayDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        view.layer.addSublayer(playerLayer)
        
        previewButton = UIButton(frame: CGRect(x: (ScreenWidth / 2) - 30, y: (ScreenHeight / 2) - 30, width: 60, height: 60))
        previewButton.setTitle("预览", for: .normal)
        previewButton.addTarget(self, action: #selector(previewCaptureVideo), for: .touchUpInside)
        previewButton.isHidden = true
        view.addSubview(previewButton)
        
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
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice)
        captureSession.addInput(audioInput);
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
                //AVVideoAverageBitRateKey视频尺寸*比率
                //AVVideoMaxKeyFrameIntervalKey关键帧最大间隔，1为每个都是关键帧，数值越大压缩率越高
                let videoCompressionProperties : [String: Any] = [AVVideoAverageBitRateKey: (1000 * 1024),
                                                                  AVVideoProfileLevelKey: AVVideoProfileLevelH264Main31,
                                                                  AVVideoMaxKeyFrameIntervalKey:(40)]
                let videoSettings: [String: Any] = [AVVideoCodecKey : AVVideoCodecH264,
                                                    AVVideoWidthKey:(480),
                                                    AVVideoHeightKey:(640),
                                                    AVVideoCompressionPropertiesKey:videoCompressionProperties]
                let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
                if assetWriter.canAdd(videoWriterInput) {
                    assetWriter.add(videoWriterInput)
                }
                var acl = AudioChannelLayout()
                bzero(&acl, MemoryLayout<AudioChannelLayout>.size)
                acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono
                
                let audioSettings: [String: Any] = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                                                    AVEncoderBitRateKey: 64000,
                                                    AVSampleRateKey: 44100.0,
                                                    AVChannelLayoutKey: Data(bytes: &acl, count: MemoryLayout<AudioChannelLayout>.size)]
                
                let audioWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio, outputSettings: audioSettings)
                //不设置true会掉帧
                audioWriterInput.expectsMediaDataInRealTime = true
                
                if assetWriter.canAdd(audioWriterInput) {
                    assetWriter.add(audioWriterInput)
                }
                

            case .unAuthorized:
                DispatchQueue.main.async { [weak self] in
                    self?.showUnAuthorizedAlert()
                }
            case .failed :
                DispatchQueue.main.async { [weak self] in
                    self?.showFailedAlert()
                }
            }
            
        }
        
    }
    //MARK: 启动录像
    func startRecord() {
        let outputFilePath = customVideoPath
        let outputURL = NSURL(fileURLWithPath: outputFilePath)
        print("开始录制")
        fileOutput.startRecording(toOutputFileURL: outputURL as URL!, recordingDelegate: self)
    }
    
    //MARK: 停止录像
    func stopRecord() {
        fileOutput.stopRecording()
    }
    
    //MARK: 删除上一个录制视频
    func deleteFile(path: String)  {
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
            } catch _ {
                
            }
             print("delete video file: \(path)")
        }
    }
    
    //MARK: 选择视频
    func chooseVideo() {
        
    }
    
    //MARK: 重新录制
    func restartRecord () {
        videoLayer.isHidden = false
        playerLayer.isHidden = true
        previewButton.isHidden = true
        deleteFile(path: customVideoPath)
        startRecord()
    }
    
    //MARK: 预览视频
    func previewCaptureVideo() {
        previewButton.isHidden = true
        let videoFileURL = URL(fileURLWithPath: customVideoPath)
        let playItem = AVPlayerItem(url: videoFileURL)
        playerLayer.player = AVPlayer(playerItem: playItem)
        playerLayer.player?.play()
        
    }
    
    //MARK: 退出录制视频页面
    func cancelViewControler () {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: （TODO）保存到相册
    //将录制好的录像保存到照片库中
    func storeVideoToPhotoLibary(outputURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }, completionHandler: { [weak self] (sucess, error) in
            
            //弹出提示框
            let alertController = UIAlertController(title: "视频保存成功", message: "是否需要回看录像？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
                //录像回看
                self?.previewCaptureVideo()
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self?.present(alertController, animated: true,
                          completion: nil)
        })
    }
    
    //MARK: (TODO)合并视频
    
    
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
    
    private final func showUnAuthorizedAlert() {
        let alertController = UIAlertController(title: "设置", message: "相机未授权", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: "去设置", style: .default, handler: { action in
            _ = UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private final func showFailedAlert() {
        let alertController = UIAlertController(title: "失败", message: "拍摄视频失败", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    fileprivate final func preparePreview() {
        previewButton.isHidden = false
        videoLayer.isHidden = true
        playerLayer.isHidden = false
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension YLRecordVideoViewController:AVCaptureFileOutputRecordingDelegate {
    public func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        preparePreview()
        
    }
}












