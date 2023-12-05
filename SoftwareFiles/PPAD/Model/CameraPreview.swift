//
//  CameraPreview.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> some UIView {
            let view = UIView()
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        previewLayer.frame = uiView.bounds
    }
}

