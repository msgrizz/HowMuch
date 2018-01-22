//
//  CameraViewController.swift
//  Text Detection Starter Project
//
//  Created by Sai Kambampati on 6/21/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import Vision


class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, RecognizerEngineDelegate, CameraView {

    let debugCeilImageView = UIImageView(frame: CGRect.zero)
    let debugFloorImageView = UIImageView(frame: CGRect.zero)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "How much"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(openSettings))
        navigationController?.navigationBar.isTranslucent = false
        
        view.addSubview(cameraView)
        view.addSubview(bottomPanelView)
        view.addSubview(debugCeilImageView)
        view.addSubview(debugFloorImageView)
        setupConstraints()
        
        presenter = CameraPresenter(view: self)
        engine.delegate = self
        startLiveVideo()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetch()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        cameraView.layer.sublayers?[0].frame = cameraView.bounds
        engine.cameraRect = cameraView.bounds
        drawCross()
    }
    
    
    
    @objc func openSettings() {
        let vc = SettingViewController(style: .grouped)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: -CameraView
    func set(settings: Settings) {
        self.settings = settings
        
        bottomPanelView.reset()
        bottomPanelView.setupCurrencies(fromCurrency: settings.sourceCurrency.sign, toCurrency: settings.resultCurrency.sign)
        engine.tryParseFloat = settings.tryParseFloat
    }
    
    
    // MARK: -Private
    private var cameraView = UIImageView()
    private var cameraLayer: AVCaptureVideoPreviewLayer!
    private let bottomPanelView = ConvertPanelView()
    private var settings = Settings()
    
    private var presenter: CameraPresenter!
    private var engine = RecognizerEngine()
    private var session = AVCaptureSession()
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
            cameraView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
            cameraView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
            cameraView.bottomAnchor.constraint(equalTo: bottomPanelView.topAnchor, constant: 0),
            ])
        
        bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomPanelView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0),
            bottomPanelView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
            bottomPanelView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
            bottomPanelView.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        debugCeilImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            debugCeilImageView.widthAnchor.constraint(equalToConstant: 50),
            debugCeilImageView.heightAnchor.constraint(equalToConstant: 50),
            debugCeilImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
            debugCeilImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0)
            ])
        
        debugFloorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            debugFloorImageView.widthAnchor.constraint(equalToConstant: 50),
            debugFloorImageView.heightAnchor.constraint(equalToConstant: 50),
            debugFloorImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
            debugFloorImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0)
            ])
    }
    
    
    private func drawCross() {
        let center = cameraView.bounds.center
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 20))
        path.close()
        
        layer.path = path.cgPath
        layer.strokeColor = UIColor.red.cgColor
        
        layer.position = CGPoint(x: center.x - 10, y: center.y - 10)
        cameraView.layer.addSublayer(layer)
    }
    
    
    private func drawWord(rect: RegionRects) {
        drawWordBorder(rect: rect.ceilRect)
        drawWordBorder(rect: rect.delimiterRect, borderColor: UIColor.blue)
        drawWordBorder(rect: rect.floorRect, borderColor: UIColor.green)
    }
    
    
    
    private func startLiveVideo() {
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
        
        session.startRunning()
    }
    
    
    
    private func drawWordBorder(rect: CGRect, borderColor: UIColor = UIColor.red) {
        let outline = CALayer()
        outline.frame = rect
        outline.borderWidth = 2.0
        outline.borderColor = borderColor.cgColor
        cameraView.layer.addSublayer(outline)
    }
    
    
    
    // MARK: -AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
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
        cameraView.layer.sublayers?.removeSubrange(2...)
    }
    
    func onDrawRect(wordRect: RegionRects) {
        drawWord(rect: wordRect)
    }
    
    func onComplete(sourceValue: Float) {
        let resultValue = presenter.calculate(sourceCurrency: settings.sourceCurrency.type, resultCurrency: settings.resultCurrency.type, from: sourceValue)
        bottomPanelView.setupValues(from: sourceValue, to: resultValue)
    }
}

