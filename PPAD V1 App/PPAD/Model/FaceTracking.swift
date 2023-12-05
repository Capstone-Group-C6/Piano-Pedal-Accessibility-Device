//
//  FaceTracking.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import Foundation
import AVFoundation
import Vision
import UIKit

class FaceTracking: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var faceDetectionRequest: VNDetectFaceRectanglesRequest?
    var sequenceHandler = VNSequenceRequestHandler()
    
    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    @Published var yaw: Double = 0
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else {return}
        
        // Set up camera input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("No front camera.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("Error setting up camera input: \(error)")
        }
        
        // Set up camera output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video.queue", qos: .background))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Set up preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        
        //Initialize face tracking
        faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: trackFaceHandler)
    }
    
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.stopRunning()
        }
    }
    
    func trackFaceHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            print("No faces detected.")
            return
        }
        for face in observations {
            DispatchQueue.main.async {
                self.roll = face.roll?.doubleValue ?? 0.0
                self.pitch = face.pitch?.doubleValue ?? 0.0
                self.yaw = face.yaw?.doubleValue ?? 0.0
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let faceDetectionRequest = faceDetectionRequest else {
            return
        }
        do {
            try sequenceHandler.perform([faceDetectionRequest], on: pixelBuffer)
        } catch {
            print("Error performing face detection: \(error)")
        }
    }
}
