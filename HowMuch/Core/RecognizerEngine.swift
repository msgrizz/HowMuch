//
//  RecognizerEngine.swift
//  HowMuch
//
//  Created by Максим Казаков on 20/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import Vision
import TesseractOCR
import AVFoundation


protocol RecognizerEngineDelegate: class {
    func onCleanRects()
    func onDrawRect(wordRect: RegionRects)
    func onComplete(sourceValue: Float)
}


class RecognizerEngine {

    var delegate: RecognizerEngineDelegate?
    
    func setup(cameraRect: CGRect, tryParseFloat: Bool) {
        self.cameraRect = cameraRect
        self.tryParseFloat = tryParseFloat
    }
    
    
    
    func perform(_ imageRequestHandler: VNImageRequestHandler, _ sampleBuffer: CMSampleBuffer) {
        guard cameraRect != .zero else {
            return
        }
        self.sampleBuffer = sampleBuffer
        do {
            try imageRequestHandler.perform([request])
        } catch {
            print(error)
        }
    }
    
    
    
    // MARK: -Private
    private var recognizeInProcess = false
    static private let gabrageString = "$£p.-,"
    static private let gabrageSet = CharacterSet(charactersIn: gabrageString)
    private let tesseractCeil = G8Tesseract(language: "eng")!
    private let tesseractFloor = G8Tesseract(language: "eng")!
    
    private var cameraRect: CGRect!
    private var tryParseFloat = false
    private var sampleBuffer: CMSampleBuffer!
    
    private lazy var request: VNRequest = {
        let request = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        request.reportCharacterBoxes = true
        return request
    }()
    
    
    private func detectTextHandler(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            self.delegate?.onCleanRects()
        }
        if let error = error {
            print(error)
            return
        }
        guard let observations = request.results else {
            return
        }
        
        let regions = observations.flatMap({$0 as? VNTextObservation})
        guard regions.count > 0 else {
            return
        }
        
        let rects = regions.flatMap {
            return self.getWordRegion(box: $0)
        }
        guard rects.count > 0 else {
            return
        }
        guard let centerRect = rects.first(where: { $0.wordRect.contains(cameraRect.center) }) else {
            return
        }
        delegate?.onDrawRect(wordRect: centerRect)
        recognizePrice(rect: centerRect)
    }
    
    
    private func recognizePrice(rect: RegionRects) {
        if recognizeInProcess {
            return
        }
        recognizeInProcess = true
        
        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        // распознаем целую часть
        guard let cgimg = image.cgImage, let ceilImage = cgimg.cropping(to: rect.ceilRect).map(UIImage.init)   else {
            return
        }
//        debugCeilImageView.image = ceilImage
        let recognizeGroup = DispatchGroup()
        
        var ceilPart = ""
        var floorPart = ""
        DispatchQueue.global(qos: .userInitiated).async(group: recognizeGroup) {
            self.recognizePrice(tesseract: self.tesseractCeil, image: ceilImage) { result in
                ceilPart = result
            }
        }
        if tryParseFloat, let floorImage = cgimg.cropping(to: rect.floorRect).map(UIImage.init)  {
//            debugFloorImageView.image = floorImage
            DispatchQueue.global(qos: .userInitiated).async(group: recognizeGroup) {
                self.recognizePrice(tesseract: self.tesseractFloor, image: floorImage) { result in
                    floorPart = result
                }
            }
        }
        
        recognizeGroup.notify(queue: .main) {
            defer {
                self.recognizeInProcess = false
            }
            // Пытаемся отбросить мусор
            ceilPart = ceilPart.trimmingCharacters(in: .whitespacesAndNewlines)
            floorPart = floorPart.trimmingCharacters(in: .whitespacesAndNewlines)
            guard (ceilPart.count == rect.ceilCount) else {
                return
            }
            //            if self.tryParseFloat && floorPart.count == rect.floorCount {
            //                floorPart = ""
            //            }
            print("ceil: \(ceilPart), floor: \(floorPart)")
            // Парсим
            if let sourceValue = self.floatFrom(ceilPart, floorPart) {
                self.delegate?.onComplete(sourceValue: sourceValue)
            }
        }
    }
    
    
    private func floatFrom(_ ceilPart: String, _ floorPart: String) -> Float? {
        guard !ceilPart.isEmpty else { return nil }
        let ceilPartTrimmed = handleStringCost(src: ceilPart)
        if tryParseFloat, !floorPart.isEmpty {
            let floorPartTrimmed = handleStringCost(src: floorPart)
            let floatString = "\(ceilPartTrimmed).\(floorPartTrimmed)"
            return Float(floatString) ?? Float(ceilPartTrimmed)
        }
        return Float(ceilPartTrimmed)
    }
    
    
    
    private func recognizePrice(tesseract: G8Tesseract, image: UIImage, callback: @escaping (String) -> Void) {
        // тут нужно добавлять символы, которые обычно могут стоять рядом с ценой
        // например валюта. Частый случай, что валюту он начинает распознавать как цифры, если
        // символ этой валюты не добавлять в whitelist
        //        let tesseract = G8Tesseract(language: "eng")!
        tesseract.charWhitelist = "0123456789-" + RecognizerEngine.gabrageString
        tesseract.engineMode = .tesseractOnly
        tesseract.pageSegmentationMode = .singleWord
        tesseract.image = image.g8_grayScale()
        tesseract.recognize()
        let result = tesseract.recognizedText ?? ""
        
        DispatchQueue.main.async {
            callback(result)
        }
    }
    
    
    
    private func handleStringCost(src: String) -> String {
        var trimed = src.trimmingCharacters(in: RecognizerEngine.gabrageSet) //.trimmingCharacters(in: .whitespacesAndNewlines)
        trimed = trimed.replacingOccurrences(of: " ", with: "")
        return trimed
    }
    
    
    /// Разбитие найденного фрагмента логические участки
    /// Стратегия: целая часть - первые символы одинакового размера,
    /// остальная часть полностью считается дробной
    private func getWordRegion(box: VNTextObservation) -> RegionRects? {
        guard let boxes = box.characterBoxes else {
            return nil
        }
        var ceilCount = 0
        var floorCount = 0
        var maxX: CGFloat = 0.0
        var minX: CGFloat = 9999.0
        var maxY: CGFloat = 0.0
        var minY: CGFloat = 9999.0
        
        let charRects = [CGRect]()
        var ceilRect = CGRect.zero
        var floorRect = CGRect.zero
        var delimiterRect = CGRect.zero
        var maxHeight: CGFloat = 0
        
        var foundCeil = false
        
        
        for char in boxes {
            let bottomLeft = char.bottomLeft
            let bottomRight = char.bottomRight
            let topRight = char.topRight
            
            if !foundCeil {
                let height = topRight.y - bottomRight.y
                if height > maxHeight {
                    maxHeight = height
                } else if height < (maxHeight * 0.8) {
                    delimiterRect = getRect(maxX: bottomRight.x, maxY: topRight.y, minX: bottomLeft.x, minY: bottomRight.y)
                    if foundCeil {
                        break
                    }
                    
                    foundCeil = true
                    ceilRect = getRect(maxX: maxX, maxY: maxY, minX: minX, minY: minY)
                    maxHeight = 0
                    maxX = 0.0
                    minX = 9999.0
                    maxY = 0.0
                    minY = 9999.0
                }
            }
            
            minY = min(bottomRight.y, minY)
            maxY = max(topRight.y, maxY)
            minX = min(bottomLeft.x, minX)
            maxX = max(bottomRight.x, maxX)
            foundCeil ? (floorCount += 1) : (ceilCount += 1)
        }
        
        if !foundCeil {
            ceilRect = getRect(maxX: maxX, maxY: maxY, minX: minX, minY: minY)
        } else {
            floorRect = getRect(maxX: maxX, maxY: maxY, minX: minX, minY: minY)
        }
        let wordRect = floorRect != CGRect.zero ? ceilRect.union(floorRect) : ceilRect
        return RegionRects(wordRect: wordRect, charRects: charRects, ceilRect: ceilRect,
                           floorRect: floorRect, delimiterRect: delimiterRect, ceilCount: ceilCount, floorCount: floorCount)
    }
    
    
    
    func getRect(maxX: CGFloat, maxY: CGFloat, minX: CGFloat, minY: CGFloat) -> CGRect {
        let viewHeight = cameraRect.size.height
        let viewWidth = cameraRect.size.width
        
        let xCord = minX * viewWidth
        let yCord = (1 - maxY) * viewHeight
        let width = (maxX - minX) * viewWidth
        let height = (maxY - minY) * viewHeight
        return CGRect(x: xCord, y: yCord, width: width, height: height)
    }
    
    
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage
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
        
        let newSize = CGSize(width: cameraRect.width, height: cameraRect.height)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
