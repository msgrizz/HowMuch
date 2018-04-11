//
//  CameraViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 27/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import ReSwift
import GoogleMobileAds


func measure(info: String = "No info", _ block: () -> ()) {
    let start = DispatchTime.now() // <<<<<<<<<< Start time
    block()
    let end = DispatchTime.now()   // <<<<<<<<<<   end time
    
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
    let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
    
    print("---\(info). Time: \(timeInterval) seconds")
}

func measure<T>(info: String = "No info", _ block: () -> (T)) -> T {
    let start = DispatchTime.now() // <<<<<<<<<< Start time
    let result = block()
    let end = DispatchTime.now()   // <<<<<<<<<<   end time
    
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
    let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
    
    print("---\(info). Time: \(timeInterval) seconds")
    return result
}


final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, SimpleStoreSubscriber {
    
    var onStateChanged: ((CameraViewController, AppState) -> Void)!
    
    struct Props {
        let status: RecongnizingStatus
        let tryParseFloat: Bool
        let onTap: (() -> Void)?
        let onRecognized: ((Float) -> Void)?
        let onWillAppear: (() -> Void)?
        let onWillDisappear: (() -> Void)?
        let showBanner: Bool
        
        static let zero = Props(status: .stopped, tryParseFloat: false,
                                onTap: nil, onRecognized: nil, onWillAppear: nil, onWillDisappear: nil, showBanner: true)
    }
    
    var props = Props.zero {
        didSet {
            engine.tryParseFloat = props.tryParseFloat
            guard oldValue.status != props.status else { return }
            
            crossView.isHidden = true
            cameraView.isHidden = true
            cameraDeniedView.isHidden = true
            disabledView.isHidden = true
            
            switch (oldValue.status, props.status) {
            case (_, .running):
                crossView.isHidden = false
                cameraView.isHidden = false
                if !session.isRunning {
                    setupLiveVideoSession()
                }
                
            case (_, .noCameraAccess):
                cameraDeniedView.isHidden = false
                
            case (_, .stopped):
                cameraView.isHidden = false
                break
                
            case (_, .suspended):
                suspend()
                disabledView.isHidden = false
                cameraView.isHidden = false
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.addSubview(dummyView)
        dummyView.addSubview(disabledView)
        dummyView.addSubview(cameraDeniedView)
        dummyView.addSubview(crossView)
        disabledView.isHidden = true
        cameraDeniedView.isHidden = true
        crossView.isHidden = false
        
        crossView.contentMode = .redraw
        
        setupConstraints()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapCamera(recognizer:)))
        dummyView.addGestureRecognizer(tapRecognizer)
        engine.delegate = self
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        props.onWillAppear?()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        props.onWillDisappear?()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        cameraView.layer.sublayers?[0].frame = cameraView.bounds
        engine.cameraRect = cameraView.bounds
    }
    
    
    // MARK: -Private    
    
    private let debugCeilImageView = UIImageView(frame: CGRect.zero)
    private let debugFloorImageView = UIImageView(frame: CGRect.zero)
    
    private var tapRecognizer: UITapGestureRecognizer!
    private var dummyView = UIView()
    private var crossView = CrossView()
    private var cameraView = UIView()
    private let cameraDeniedView = CameraAccessDeniedView()
    private let disabledView = DisabledCameraView()
    
    private var session = AVCaptureSession()
    private let engine = RecognizerEngine()
    private let sessionQueue = DispatchQueue(label: "session")
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            cameraView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0),
            cameraView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0),
            cameraView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0),
            ])
        
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dummyView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            dummyView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            dummyView.widthAnchor.constraint(equalTo: cameraView.widthAnchor),
            dummyView.heightAnchor.constraint(equalTo: cameraView.heightAnchor),
            ])
        
        disabledView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cameraDeniedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        crossView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    
    private func drawWord(rect: RegionRects) {
        drawWordBorder(rect: rect.ceilRect)
        drawWordBorder(rect: rect.delimiterRect, borderColor: UIColor.blue)
        drawWordBorder(rect: rect.floorRect, borderColor: UIColor.green)
    }
    
    
    
    private func setupLiveVideoSession() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                return
        }
        
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(cameraLayer)
        view.setNeedsLayout()
        
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    
    
    
    
    private func drawWordBorder(rect: CGRect, borderColor: UIColor = UIColor.red) {
        let outline = CALayer()
        outline.frame = rect
        outline.borderWidth = 2.0
        outline.borderColor = borderColor.cgColor
        cameraView.layer.addSublayer(outline)
    }
    
    
    
    private func suspend() {
        onCleanRects()
    }
    
    
    
    @objc private func onTapCamera(recognizer: UIGestureRecognizer) {
        props.onTap?()
    }
    
    
    
    // MARK: -AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard props.status == .running, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        var requestOptions: [VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics : camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        engine.perform(imageRequestHandler, sampleBuffer)
    }
}



extension CameraViewController: RecognizerEngineDelegate {
    func onCleanRects() {
        let count = cameraView.layer.sublayers?.count ?? 0
        guard count > 1 else {
            return
        }
        cameraView.layer.sublayers?.removeSubrange(1...)
    }
    
    
    
    func onDrawRect(wordRect: RegionRects) {
        guard props.status.isRunning else { return }
        drawWord(rect: wordRect)
    }
    
    
    
    func onComplete(sourceValue: Float) {
        guard props.status.isRunning else { return }
        props.onRecognized?(sourceValue)
    }
}
