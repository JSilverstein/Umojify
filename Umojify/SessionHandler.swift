//
//  SessionHandler.swift
//  Umojify
//
//  Created by Jacob Silverstein on 8/5/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit
import AVFoundation

class SessionHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var session = AVCaptureSession()
    let layer = AVSampleBufferDisplayLayer()
    let sampleQueue = DispatchQueue(label: "sample queue", attributes: [])
    let faceQueue = DispatchQueue(label: "face queue", attributes: [])
    let wrapper = DlibWrapper()
    var hasFace = 2
    
    var currentMetadata: [AnyObject]
    
    override init() {
        currentMetadata = []
        super.init()
    }
    
    func getArray() -> Array<Int> {
        var dataArray = Array<Int>()
        for x in 0...67 {
            //print(wrapper.getPointForIndex(1, coord: Int32(x)), wrapper.getPointForIndex(2, coord: Int32(x)))
            dataArray.append((wrapper?.getPointFor(1, coord: Int32(x)))!)
            dataArray.append((wrapper?.getPointFor(2, coord: Int32(x)))!)
        }
        return dataArray
    }
    
    func openSession() {
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            .map { $0 as! AVCaptureDevice }
            .filter { $0.position == .front}
            .first!

        let input = try! AVCaptureDeviceInput(device: device)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: faceQueue)
        
        session.beginConfiguration()
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        if session.canAddOutput(metaOutput) {
            session.addOutput(metaOutput)
        }
        
        output.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.portrait
        output.connection(withMediaType: AVMediaTypeVideo).isVideoMirrored = true
    
        session.commitConfiguration()
        
        let settings: [AnyHashable: Any] = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = settings
        
        // availableMetadataObjectTypes change when output is added to session.
        // before it is added, availableMetadataObjectTypes is empty
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        
        wrapper?.prepare()
        
        session.startRunning()
    }
    
    func stopRunning() {
        session.stopRunning()
    }
    
    func startRunning() {
        session.startRunning()
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        
        if !currentMetadata.isEmpty {
            let boundsArray = currentMetadata
                .flatMap { $0 as? AVMetadataFaceObject }
                .map { NSValue(cgRect: CGRect(x: $0.bounds.minY, y: $0.bounds.minX, width: $0.bounds.size.height, height: $0.bounds.size.width)) }
            
            wrapper?.doWork(on: sampleBuffer, inRects: boundsArray)
            
            if hasFace != 1 {
                hasFace = 1
                NotificationCenter.default.post(name: Notification.Name(rawValue: "update"), object: hasFace)
            }

        } else {
            if hasFace != 0 {
                hasFace = 0
                NotificationCenter.default.post(name: Notification.Name(rawValue: "update"), object: hasFace)
            }
        }


        layer.enqueue(sampleBuffer)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        print("DidDropSampleBuffer")
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        currentMetadata = metadataObjects as [AnyObject]
    }
}
