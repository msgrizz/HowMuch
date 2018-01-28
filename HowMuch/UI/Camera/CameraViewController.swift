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

class CameraViewController: UIViewController, CameraView, RecognizerEngineDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let debugCeilImageView = UIImageView(frame: CGRect.zero)
    let debugFloorImageView = UIImageView(frame: CGRect.zero)
    
    
    
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
        
        presenter = CameraPresenter(view: self)
        engine.delegate = self
        setupLiveVideoSession()                
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetch()
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
    
    
    
    // MARK: -CameraView
    func set(settings: Settings) {
        self.settings = settings                
        engine.tryParseFloat = settings.tryParseFloat
    }
    
    
    // MARK: -Private
   
    private var tapRecognizer: UITapGestureRecognizer!
    private var isSuspended = false
    private var crossView = CrossView()
    private var dummyView = UIView()
    private var cameraView = UIView()
    private var cameraLayer: AVCaptureVideoPreviewLayer!
    
    private var settings = Settings()
    private let disabledView = DisabledCameraView()
    
    private var presenter: CameraPresenter!
    private var engine = RecognizerEngine()
    private var session = AVCaptureSession()
    
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
    
    
    private func suspend() {
        onCleanRects()
        isSuspended = true
        disabledView.isHidden = false
        crossView.isHidden = true
    }
    
    
    private func resume() {
        isSuspended = false
        disabledView.isHidden = true
        crossView.isHidden = false
    }
    
    
    @objc func onTapCamera(recognizer: UIGestureRecognizer) {
        isSuspended ? resume() : suspend()
    }
    
    
    
    // MARK: -AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !isSuspended, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        var requestOptions: [VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics : camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        engine.perform(imageRequestHandler, sampleBuffer)
    }
    
    
    
    // MARK: -RecognizerEngineDelegate
    func onCleanRects() {
        if isSuspended  { return }
        let count = cameraView.layer.sublayers?.count ?? 0
        guard count > 1 else {
            return
        }
        cameraView.layer.sublayers?.removeSubrange(1...)
    }
    
    
    
    func onDrawRect(wordRect: RegionRects) {
        if isSuspended { return }
        drawWord(rect: wordRect)
    }
    
    
    
    func onComplete(sourceValue: Float) {
        if isSuspended { return }
//        let resultValue = calculate(from: sourceValue)
//        convertPanelView.setupValues(from: sourceValue, to: resultValue)
    }
    
    
    
    func calculate(from source: Float) -> Float {
        return presenter.calculate(sourceCurrency: settings.sourceCurrency.type, resultCurrency: settings.resultCurrency.type, from: source)
    }
}



extension CameraViewController: ConvertPanelViewDelegate {
    func onSwap() {
        let source = settings.sourceCurrency
        settings.sourceCurrency = settings.resultCurrency
        settings.resultCurrency = source
        set(settings: settings)
        presenter.save(settings: settings)
    }
    
    
    func onChanged(value: String) {
//        let result = calculate(from: value.float)
//        convertPanelView.set(result: result)
    }
}

