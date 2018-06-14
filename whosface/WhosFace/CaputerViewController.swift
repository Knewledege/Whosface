//
//  CaputerViewController.swift
//  WhosFace
//
//  Created by Kei on 2017/08/11.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit
import AVFoundation

class CaputerViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate  {
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var shutter: UIButton!
    var image:UIImage!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    // @IBOutlet weak var displayImageView: UIImageView!
    
    // セッション
    var mySession : AVCaptureSession!
    // カメラデバイス
    var myDevice : AVCaptureDevice!
    // 出力先
    var myOutput : AVCaptureVideoDataOutput!
    
    // 顔検出オブジェクト
    let detector = OpenCVWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Bundle.main.resourcePath!)
        // カメラを準備
        if initCamera() {
            // 撮影開始
            mySession.startRunning()
        }
        self.shutter.isHidden = false
    }
    
    
    // カメラの準備処理
    func initCamera() -> Bool {
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // 解像度の指定.
        mySession.sessionPreset = AVCaptureSessionPresetMedium
        
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                //                if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        if myDevice == nil {
            return false
        }
        
        // バックカメラからVideoInputを取得.
        var myInput: AVCaptureDeviceInput! = nil
        do {
            myInput = try AVCaptureDeviceInput(device: myDevice) as AVCaptureDeviceInput
        } catch let error {
            print(error)
        }
        
        // セッションに追加.
        if mySession.canAddInput(myInput) {
            mySession.addInput(myInput)
        } else {
            return false
        }
        
        // 出力先を設定
        myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA) ]
        
        
        
        // FPSを設定
        do {
            try myDevice.lockForConfiguration()
            
            myDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15)
            myDevice.unlockForConfiguration()
        } catch let error {
            print("lock error: \(error)")
            return false
        }
        
        // デリゲートを設定
        let queue: DispatchQueue = DispatchQueue(label: "myqueue",  attributes: [])
        myOutput.setSampleBufferDelegate(self, queue: queue)
        
        
        // 遅れてきたフレームは無視する
        myOutput.alwaysDiscardsLateVideoFrames = true
        
        // セッションに追加.
        if mySession.canAddOutput(myOutput) {
            mySession.addOutput(myOutput)
        } else {
            return false
        }
        
        // カメラの向きを合わせる
        for connection in myOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.isVideoOrientationSupported {
                    conn.videoOrientation = AVCaptureVideoOrientation.portrait
                }
            }
        }
        
        return true
    }
    
    
    
    // 毎フレーム実行される処理
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        DispatchQueue.main.sync(execute: {
            // UIImageへ変換
            image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            
            // 顔認識
            let faceImage = self.detector?.recognizeFace(image)
            
            self.shutter.isHidden = false
            // 表示
            self.displayImageView.image = faceImage
        })
    }
    
    
    @IBAction func shutter(_ sender: UIButton) {
        
        mySession.stopRunning()
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "showimage") as! ShowImageViewController
        nextView.image = image
        self.present(nextView, animated: true, completion: nil)
        print(Bundle.main.resourcePath!)
    }
    
    
}
