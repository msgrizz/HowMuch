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
import TesseractOCR




class CameraViewController: UIViewController {
    struct RegionRects {
        let wordRect: CGRect
        let charRects: [CGRect]
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "How much"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(openSettings))
        navigationController?.navigationBar.isTranslucent = false
        
        view.addSubview(cameraView)
        view.addSubview(bottomPanelView)
        setupConstraints()
        
        startLiveVideo()
        startTextDetection()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let signs = presenter.signs
        bottomPanelView.reset()
        bottomPanelView.setupCurrencies(fromCurrency: signs.from, toCurrency: signs.to)
    }
    
    
    
    @objc func openSettings() {
        let vc = SettingViewController(style: .grouped)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        cameraView.layer.sublayers?[0].frame = cameraView.bounds
        drawCross()
    }
    
    
    // MARK: -Private
    private var cameraView = UIImageView()
    private var cameraLayer: AVCaptureVideoPreviewLayer!
    
    private let bottomPanelView = ConvertPanelView()
    private let presenter = CameraPresenter()
    
    
    private var session = AVCaptureSession()
    private var requests = [VNRequest]()
    
    static private let gabrageString = "$£p"
    static private let gabrageSet = CharacterSet(charactersIn: gabrageString)
    private var captureBuffer: CMSampleBuffer!
    private var pixelBuffer: CVImageBuffer!
    private var recognizeInProcess = false
    
    
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
    
    
    
    
    
    private func startTextDetection() {
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    
    
    private func detectTextHandler(request: VNRequest, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        let regions = observations.flatMap({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            
            let rects = regions.flatMap {
                return self.getWordRegion(box: $0)
            }
            guard rects.count > 0 else {
                return
            }
            let centerPoint = self.cameraView.bounds.center
            
            self.cameraView.layer.sublayers?.removeSubrange(2...)
            // обработка со слова в центре
            guard let centerRect = rects.first(where: { $0.wordRect.contains(centerPoint)} ) else {
                return
            }
            
            let wordRect = centerRect.wordRect
            self.drawWordBorder(rect: wordRect)
            self.capturePrice(rect: wordRect)
        }
    }
    
    
    
    private func getWordRegion(box: VNTextObservation) -> RegionRects? {
        guard let boxes = box.characterBoxes else {
            return nil
        }
        
        let viewHeight = cameraView.frame.size.height
        let viewWidth = cameraView.frame.size.width
        
        var maxX: CGFloat = 0.0
        var minX: CGFloat = 9999.0
        var maxY: CGFloat = 0.0
        var minY: CGFloat = 9999.0
        
        var charRects = [CGRect]()
        //        var maxHeight: CGFloat = 0
        
        for char in boxes {
            let bottomLeft = char.bottomLeft
            let bottomRight = char.bottomRight
            let topRight = char.topRight
            
            // Если высота следующего символа вдруг резко падает - дальше не читаем
            //            let height = topRight.y - bottomRight.y
            //            if height > maxHeight {
            //                maxHeight = height
            //            } else if height < (maxHeight * 0.85) {
            //                break
            //            }
            
            charRects.append(CGRect(x: bottomLeft.x * viewWidth,
                                    y: (1 - topRight.y) * viewHeight,
                                    width: (bottomRight.x - bottomLeft.x) * viewWidth,
                                    height: (topRight.y - bottomRight.y) * viewHeight))
            
            
            if char.bottomRight.y < minY {
                minY = bottomRight.y
            }
            if char.topRight.y > maxY {
                maxY = topRight.y
            }
            
            if char.bottomLeft.x < minX {
                minX = bottomLeft.x
            }
            if char.bottomRight.x > maxX {
                maxX = bottomRight.x
            }
        }
        let xCord = minX * viewWidth
        let yCord = (1 - maxY) * viewHeight
        let width = (maxX - minX) * viewWidth
        let height = (maxY - minY) * viewHeight
        
        
        let rect = CGRect(x: xCord, y: yCord, width: width, height: height)
        return RegionRects(wordRect: rect, charRects: charRects)
    }
    
    
    
    
    private func drawWordBorder(rect: CGRect, borderColor: UIColor = UIColor.red) {
        let outline = CALayer()
        outline.frame = rect
        outline.borderWidth = 2.0
        outline.borderColor = borderColor.cgColor
        
        cameraView.layer.addSublayer(outline)
    }
    
    
    
    private func capturePrice(rect: CGRect) {
        let image = imageFromSampleBuffer(sampleBuffer: captureBuffer)
        
        guard let cgimg = image.cgImage?.cropping(to: rect) else {
            return
        }
        let img = UIImage(cgImage: cgimg)
        //        captureImageView.image = img
        
        if recognizeInProcess {
            return
        }
        recognizeInProcess = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let tesseract = G8Tesseract(language: "eng") {
                
                // тут нужно добавлять символы, которые обычно могут стоять рядом с ценой
                // например валюта. Частый случай, что валюту он начинает распознавать как цифры, если
                // символ этой валюты не добавлять в whitelist
                tesseract.charWhitelist = "0123456789-." + CameraViewController.gabrageString
                
                tesseract.engineMode = .tesseractOnly
                tesseract.pageSegmentationMode = .singleWord
                //                tesseract.image = img.g8_blackAndWhite()
                tesseract.image = img.g8_grayScale()
                
                tesseract.recognize()
                
                DispatchQueue.main.async {
                    //                    self.textView.text = "Cannot recognize"
                    //                    print(tesseract.recognizedText)
                    if let resultText = tesseract.recognizedText,
                        !resultText.isEmpty {
                        let trimed = self.handleStringCost(src: resultText)
                        print("--TRIMED: \(trimed)")
                        
                        if let sourceValue = Float(trimed) {
                            let resultValue = self.presenter.calculate(from: sourceValue)
                            self.bottomPanelView.setupValues(from: sourceValue, to: resultValue)
                        }
                    }
                    
                    self.recognizeInProcess = false
                }
            }
        }
    }
    
    
    private func handleStringCost(src: String) -> String {
        var trimed = src.trimmingCharacters(in: CameraViewController.gabrageSet).trimmingCharacters(in: .whitespacesAndNewlines)
        trimed = trimed.replacingOccurrences(of: " ", with: "")
        return trimed
    }
    
    
    
    
    private func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        // Create an image object from the Quartz image
        //        let image = UIImage.init(cgImage: quartzImage!);
        let image = UIImage.init(cgImage: quartzImage!, scale: 1.0, orientation: UIImageOrientation.right)
        
        let newSize = CGSize(width: cameraView.frame.width, height: cameraView.frame.height)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}



extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        self.pixelBuffer = pixelBuffer
        self.captureBuffer = sampleBuffer
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}


