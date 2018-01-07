//
//  ViewController.swift
//  Text Detection Starter Project
//
//  Created by Sai Kambampati on 6/21/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import TesseractOCR


struct RegionRects {
    let wordRect: CGRect
    let charRects: [CGRect]
}


class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captureImageView: UIImageView!
    
    
    @IBOutlet weak var textView: UILabel!
    
    var session = AVCaptureSession()
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLiveVideo()
        startTextDetection()
    }
    

    
    func drawCross() {
        let center = imageView.bounds.center
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 20))
        path.close()
        
//        path.addArc(withCenter: center, radius: 20, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path = path.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.borderWidth = 3
        
        layer.position = CGPoint(x: center.x - 10, y: center.y - 10)
//        layer.frame = CGRect(origin: , size: CGSize(width: 20, height: 20))
        imageView.layer.addSublayer(layer)
    }
    
    
    
    private func startLiveVideo() {
        //1
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //2
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        //3
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
        drawCross()
    }
    
    
    
    func startTextDetection() {
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    
    
    func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        let regions = observations.flatMap({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            self.imageView.layer.sublayers?.removeSubrange(2...)
            
            let rects = regions.flatMap {
                return self.getWordRegion(box: $0)
            }
            guard rects.count > 0 else {
                return
            }
            let centerPoint = self.imageView.bounds.center
//            rects.forEach{ self.drawWordBorder(rect: $0.wordRect, borderColor: UIColor.green) }
            
            
            // обработка со слова в центре
            let centerRect = rects.first{
                $0.wordRect.contains(centerPoint)
            }
            if let rect = centerRect {
                let wordRect = rect.wordRect
                self.drawWordBorder(rect: wordRect)
                self.capturePrice(rect: wordRect)
                rect.charRects.forEach{
                    self.drawWordBorder(rect: $0, borderColor: UIColor.blue)
                }
            }
        }
    }
    
    
    
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * imageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        imageView.layer.addSublayer(outline)
    }
    
    
    func getWordRegion(box: VNTextObservation) -> RegionRects? {
        guard let boxes = box.characterBoxes else {
            return nil
        }
        
        let viewHeight = imageView.frame.size.height
        let viewWidth = imageView.frame.size.width
        
        var maxX: CGFloat = 0.0
        var minX: CGFloat = 9999.0
        var maxY: CGFloat = 0.0
        var minY: CGFloat = 9999.0
        
        var charRects = [CGRect]()
        var maxHeight: CGFloat = 0
        
        for char in boxes {
            let bottomLeft = char.bottomLeft
            let bottomRight = char.bottomRight
            let topRight = char.topRight
            
            // Если высота следующего символа вдруг резко падает - дальше не читаем
            let height = topRight.y - bottomRight.y
            if height > maxHeight {
                maxHeight = height
            } else if height < (maxHeight * 0.85) {
                break
            }
            
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
    
    
    
    
    func drawWordBorder(rect: CGRect, borderColor: UIColor = UIColor.red) {
        let outline = CALayer()
        outline.frame = rect
        outline.borderWidth = 2.0
        outline.borderColor = borderColor.cgColor
        
        imageView.layer.addSublayer(outline)
    }
    
    
    private var recognizeInProcess = false
    static private let gabrageString = "$£p"
    static private let gabrageSet = CharacterSet(charactersIn: gabrageString)
    
    
    
    func capturePrice(rect: CGRect) {
        let image = imageFromSampleBuffer(sampleBuffer: captureBuffer)
        
        guard let cgimg = image.cgImage?.cropping(to: rect) else {
            return
        }
        let img = UIImage(cgImage: cgimg)
        captureImageView.image = img
        
        if recognizeInProcess {
            return
        }
        recognizeInProcess = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let tesseract = G8Tesseract(language: "eng") {
                
                // тут нужно добавлять символы, которые обычно могут стоять рядом с ценой
                // например валюта. Частый случай, что валюту он начинает распознавать как цифры, если
                // символ этой валюты не добавлять в whitelist
                tesseract.charWhitelist = "0123456789-." + ViewController.gabrageString

                tesseract.engineMode = .tesseractOnly
                // 3
                tesseract.pageSegmentationMode = .singleWord
                // 4
//                tesseract.image = img.g8_blackAndWhite()
                tesseract.image = img.g8_grayScale()
                // 5
                tesseract.recognize()
                // 6
                DispatchQueue.main.async {
                    self.textView.text = "Cannot recognize"
//                    print(tesseract.recognizedText)
                    if let resultText = tesseract.recognizedText,
                        !resultText.isEmpty {
                        let trimed = self.handleStringCost(src: resultText)
                        print("--TRIMED: \(trimed)")
                        
                        if let double = Double(trimed) {
                            self.textView.text = trimed
//                            print(double)
                        }
                    }
                    
                    self.recognizeInProcess = false
                }
            }
        }
    }
    
    
    private func handleStringCost(src: String) -> String {
        var trimed = src.trimmingCharacters(in: ViewController.gabrageSet).trimmingCharacters(in: .whitespacesAndNewlines)
        trimed = trimed.replacingOccurrences(of: " ", with: "")
        return trimed
    }
    
    
    
    var captureBuffer: CMSampleBuffer!
    var pixelBuffer: CVImageBuffer!
    
    
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
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
        
        let newSize = CGSize(width: imageView.frame.width, height: imageView.frame.height)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}



extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
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


extension CGRect {
    var center: CGPoint {
        return CGPoint(x: maxX - width / 2, y: maxY - height / 2)
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = x - point.x
        let yDist = y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}
