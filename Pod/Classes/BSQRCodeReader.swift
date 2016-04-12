//
//  BSQRCodeReader.swift
//  v1.0.0
//  This plugin is created to read QR Code inside your app. 
//  BSQRCodeReader is inherited from UIView so you can use your own page design and 
//  include this reader to be part of your layout.
//
//  Created by Bobby Stenly Irawan (iceman.bsi@gmail.com) on 4/12/16.
//  for more information please visit https://github.com/icemanbsi/BSQRCodeReader
//

import Foundation
import UIKit
import AVFoundation

public protocol BSQRCodeReaderDelegate {
    func didFailWithError(error: NSError)
    func didCaptureQRCodeWithContent(content: String) -> Bool
    func beforeStartScanning(reader: BSQRCodeReader)
    func afterStopScanning(reader: BSQRCodeReader)
}

public extension BSQRCodeReaderDelegate {
    func didFailWithError(error: NSError) { }
    func didCaptureQRCodeWithContent(content: String) -> Bool { return true }
    func beforeStartScanning(reader: BSQRCodeReader) { }
    func afterStopScanning(reader: BSQRCodeReader) { }
}

public class BSQRCodeReader: UIView, AVCaptureMetadataOutputObjectsDelegate {

    // -- public attributes
    public var delegate: BSQRCodeReaderDelegate?
    // -- public attributes
    
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice? = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var deviceInput: AVCaptureDeviceInput?
    var metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup(){
        let preset = AVCaptureSessionPresetHigh
        if self.captureSession.canSetSessionPreset(preset) {
            self.captureSession.sessionPreset = preset
        }
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer.frame = self.bounds
        
        do {
            self.deviceInput = try AVCaptureDeviceInput(device: self.captureDevice)
        } catch let error as NSError {
            if let delegate = self.delegate {
                delegate.didFailWithError(error)
            }
            return
        }
        
        if let captureInput = self.deviceInput {
            self.captureSession.addInput(captureInput)
        }
        
        self.metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        self.captureSession.addOutput(self.metadataOutput)
        
        self.metadataOutput.metadataObjectTypes = self.metadataOutput.availableMetadataObjectTypes
        
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(self.videoPreviewLayer)
        
        self.updateVideoOrientation(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    private func updateVideoOrientation(orientation:UIInterfaceOrientation){
        
        switch orientation {
        case .Portrait :
            videoPreviewLayer.connection?.videoOrientation = .Portrait
            break
        case .PortraitUpsideDown :
            videoPreviewLayer.connection?.videoOrientation = .PortraitUpsideDown
            break
        case .LandscapeLeft :
            videoPreviewLayer.connection?.videoOrientation = .LandscapeLeft
            break
        case .LandscapeRight :
            videoPreviewLayer.connection?.videoOrientation = .LandscapeRight
            break
        default:
            videoPreviewLayer.connection?.videoOrientation = .Portrait
        }
    }
    
    
    
    public func startScanning() {
        self.captureSession.startRunning()
    }
    
    public func stopScanning() {
        self.captureSession.stopRunning()
    }
    
    
    // -- MARK : AVCaptureMetadataOutputObjectsDelegate
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var detectionString:String?
        
        for metadata in metadataObjects {
            if let metadataObject = metadata as? AVMetadataObject {
                
                if (metadataObject.type == AVMetadataObjectTypeQRCode) {
                    if let machineReadableObject = metadataObject as? AVMetadataMachineReadableCodeObject {
                        detectionString = machineReadableObject.stringValue
                    }
                }
                
                if let qrCodeContent = detectionString {
                    self.stopScanning()
                    if let delegate = self.delegate {
                        if !delegate.didCaptureQRCodeWithContent(qrCodeContent) {
                            self.startScanning()
                        }
                    }
                    return
                }
            }
        }
        
    }
}
