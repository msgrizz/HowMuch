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

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    struct Props {
        let recognizingStatus: RecongnizingStatus
        let isManualEditing: Bool
        let onTap: ((RecongnizingStatus) -> Void)?
        let onRecognized: ((Float) -> Void)?
        let tryParseFloat: Bool
        
        static let zero = Props(recognizingStatus: .running, isManualEditing: false, onTap: nil, onRecognized: nil, tryParseFloat: false)
    }
    
    var props = Props.zero {
        didSet {
            switch (oldValue.recognizingStatus, props.recognizingStatus) {
            case (.running, .stopped), (.suspended, .stopped):
                stop()
            case (.running, .suspended):
                suspend()
            case (.suspended, .running):
                resume()
            case (.stopped, .running):
                start()
            default:
                break
            }
            engine.tryParseFloat = props.tryParseFloat
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cameraView)
        view.addSubview(dummyView)
        dummyView.addSubview(disabledView)
        dummyView.addSubview(crossView)
        disabledView.isHidden = true
        crossView.isHidden = false
        
//        contentView.addSubview(debugCeilImageView)
//        contentView.addSubview(debugFloorImageView)
        setupConstraints()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapCamera(recognizer:)))
        dummyView.addGestureRecognizer(tapRecognizer)
        
        engine.delegate = self
        setupLiveVideoSession()                
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        cameraView.layer.sublayers?[0].frame = cameraView.bounds
        engine.cameraRect = cameraView.bounds
    }
    
    
    // MARK: -Private
    private let debugCeilImageView = UIImageView(frame: CGRect.zero)
    private let debugFloorImageView = UIImageView(frame: CGRect.zero)
    
    private var tapRecognizer: UITapGestureRecognizer!
    private var crossView = CrossView()
    private var dummyView = UIView()
    private var cameraView = UIView()
    private var cameraLayer: AVCaptureVideoPreviewLayer!
    private let disabledView = DisabledCameraView()
    
    private var session = AVCaptureSession()
    private let engine = RecognizerEngine()
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: 0),
            cameraView.heightAnchor.constraint(equalTo: guide.heightAnchor, constant: 0),
            cameraView.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
            cameraView.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: 0),
            ])
        
        //        debugCeilImageView.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            debugCeilImageView.widthAnchor.constraint(equalToConstant: 50),
        //            debugCeilImageView.heightAnchor.constraint(equalToConstant: 50),
        //            debugCeilImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
        //            debugCeilImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0)
        //            ])
        //
        //        debugFloorImageView.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            debugFloorImageView.widthAnchor.constraint(equalToConstant: 50),
        //            debugFloorImageView.heightAnchor.constraint(equalToConstant: 50),
        //            debugFloorImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
        //            debugFloorImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0)
        //            ])
        
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dummyView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            dummyView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            dummyView.widthAnchor.constraint(equalTo: cameraView.widthAnchor),
            dummyView.heightAnchor.constraint(equalTo: cameraView.heightAnchor),
            ])
        
        disabledView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
    }
    
    
    
    private func drawWordBorder(rect: CGRect, borderColor: UIColor = UIColor.red) {
        let outline = CALayer()
        outline.frame = rect
        outline.borderWidth = 2.0
        outline.borderColor = borderColor.cgColor
        cameraView.layer.addSublayer(outline)
    }
    
    
    private func start() {
        session.startRunning()
    }
    
    
    private func stop() {
        session.stopRunning()
    }
    
    
    private func resume() {
        disabledView.isHidden = true
        crossView.isHidden = false
    }
    
    
    private func suspend() {
        onCleanRects()
        disabledView.isHidden = false
        crossView.isHidden = true
    }
    
    
    @objc private func onTapCamera(recognizer: UIGestureRecognizer) {        
        switch props.recognizingStatus {
        case .running:
            props.onTap?(.suspended)
        case .suspended:
            if props.isManualEditing { return }
            props.onTap?(.running)
        case .stopped:
            return
        }
    }
    
    
    
    // MARK: -AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard props.recognizingStatus == .running, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
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
        guard props.recognizingStatus == .running else { return }
        drawWord(rect: wordRect)
    }
    
    
    
    func onComplete(sourceValue: Float) {
        guard props.recognizingStatus == .running else { return }
        props.onRecognized?(sourceValue)
    }
}


extension CameraViewController:  StoreSubscriber {
    func connect(to store: Store<AppState>) {
        store.subscribe(self)
    }
    
    
    func newState(state: AppState) {
        props = Props(recognizingStatus: state.recognizing.recongnizingStatus, isManualEditing: state.recognizing.isManuallyEditing,
                      onTap: { status in
                        store.dispatch(SetRecognizingStatusAction(status: status))
        },
                      onRecognized: { (value: Float) in
                        store.dispatch(CreateSetValuesAction(state: state, source: value))
        },
                      tryParseFloat: state.settings.tryParseFloat)
    }
}

