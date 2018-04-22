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

struct RegionRects {
    /// Прямоугольник всего слова
    let wordRect: CGRect
    /// Прямоугольники посимвольно
    let charRects: [CGRect]
    /// Прямоугольник с целой частью
    let ceilRect: CGRect
    /// Прямоугольник с дробной частью
    let floorRect: CGRect
    /// Прямоугольник с разделителем
    let delimiterRect: CGRect
    /// Количество знаков в целой части
    let ceilCount: Int
    /// Количество знаков в дробной части
    let floorCount: Int
}


protocol RecognizerEngineDelegate: class {
    func onCleanRects()
    func onDrawRect(wordRect: RegionRects)
    func onDrawCeil(image: UIImage)
    func onComplete(sourceValue: Float)
}


class RecognizerEngine {
    weak var delegate: RecognizerEngineDelegate?
    var cameraRect = CGRect.zero
    var tryParseFloat = false    

    
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
    
    
    
    init() {
        ceilSerialQueue.async {
            self.tesseractCeil = G8Tesseract(language: "eng")
        }
        floorSerialQueue.async {
            self.tesseractFloor = G8Tesseract(language: "eng")
        }
    }
    
    // MARK: -Private
    private var recognizeInProcess = false
    static private let gabrageString = "ABCDEFGHJKLMNOPQRTUVWXY$£p.-,₽£€₣₡₦Sh₾c฿¥₲"
    static private let gabrageSet = CharacterSet(charactersIn: gabrageString)
    private var tesseractCeil: G8Tesseract!
    private var tesseractFloor: G8Tesseract!
    private let ceilSerialQueue = DispatchQueue(label: "ceilSerialQueue", qos: .utility)
    private let floorSerialQueue = DispatchQueue(label: "floorSerialQueue", qos: .utility)
    
    
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
        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        
        let rects = regions.flatMap {
            return self.getWordRegion(box: $0)
        }
        guard rects.count > 0 else {
            return
        }
        
        guard let centerRect = rects.first(where: {
            $0.wordRect.contains(cameraRect.center)
        }) else {
            return
        }
        DispatchQueue.main.async {
            self.delegate?.onDrawRect(wordRect: centerRect)
        }
        recognizePrice(rect: centerRect, image: image)
    }
    
    
    private func recognizePrice(rect: RegionRects, image: UIImage) {
        if recognizeInProcess {
            return
        }

        // распознаем целую часть
        guard let cgimg = image.cgImage, let ceilImage = cgimg.cropping(to: rect.ceilRect).map(UIImage.init)   else {
            return
        }
        recognizeInProcess = true
        
        DispatchQueue.main.async {
            self.delegate?.onDrawCeil(image: ceilImage)
        }
        
        let recognizeGroup = DispatchGroup()
        
        var ceilPart = ""
        var floorPart = ""
        ceilSerialQueue.async(group: recognizeGroup) {
            self.recognizePrice(tesseract: self.tesseractCeil, image: ceilImage) { result in
                ceilPart = result
            }
        }
        if tryParseFloat, let floorImage = cgimg.cropping(to: rect.floorRect).map(UIImage.init)  {
//            debugFloorImageView.image = floorImage
            floorSerialQueue.async(group: recognizeGroup) {
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
            #if DEBUG
//            print("ceil: \(ceilPart), floor: \(floorPart)")
            #endif
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
        var trimed = src.trimmingCharacters(in: RecognizerEngine.gabrageSet)
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
        let dx = scaledRect.origin.x
        let dy = scaledRect.origin.y
        
        let width = scaledRect.width
        let height = scaledRect.height
        
        let xCord = minX * width + dx
        let yCord = (1 - maxY) * height + dy
        let rectWidth = (maxX - minX) * width
        let rectHeight = (maxY - minY) * height
        let resRect = CGRect(x: xCord, y: yCord, width: rectWidth, height: rectHeight)
        return resRect
    }
            
    private var scaledRect = CGRect.zero
    
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly);
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
            bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly);
        
        // Create an image object from the Quartz image
        let image = UIImage(cgImage: quartzImage!, scale: UIScreen.main.scale, orientation: UIImageOrientation.right)
        let newImage: UIImage
        (scaledRect, newImage) = image.scaled(to: cameraRect.size)
    
        return newImage
    }
}
