//
//  VisionManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import UIKit
import Vision

struct VisionManager {    
    func vnRecognizeRequest(image: UIImage) -> [String]? {
        guard let cgImage = image.cgImage else { return nil }
        var result: [String]? = []
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest { request, error in
            result = recognizeTextHandler(request: request, error: error)
        }
        request.recognitionLanguages = ["ko_KR"]

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        return result
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) -> [String]? {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return nil }
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        return recognizedStrings
    }
}

extension VisionManager {
    // 1. 바코드 영역을 가져오는 함수
    func recognizeBarCodeRectangle(_ barcodeImage: UIImage, completion: @escaping (UIImage) -> Void) {
        guard let cgImage = barcodeImage.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNDetectBarcodesRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let results = request.results as? [VNBarcodeObservation] else { return }
            if let observation = results.first {
                let rect = observation.boundingBox
                let size = CGSize(width: cgImage.width, height: cgImage.height)
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -size.height)
                let translate = CGAffineTransform.identity.scaledBy(x: size.width, y: size.height)
                let convertedRect = rect.applying(translate).applying(transform)
                let x = convertedRect.origin.x * barcodeImage.size.width
                let y = convertedRect.origin.y * barcodeImage.size.height
                
                let width = convertedRect.size.width * barcodeImage.size.height
                let height = convertedRect.size.height * barcodeImage.size.height
                
                let cropRect = CGRect(x: x, y: y, width: width, height: height)
                
                if let croppedCGImage = cgImage.cropping(to: cropRect) {
                    let croppedUIImage = UIImage(cgImage: croppedCGImage)
                    DispatchQueue.main.async {
                        completion(croppedUIImage)
                    }
                }
            }
        }
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error.localizedDescription)")
        }
        
        
    }
    
    // 2. rect에 따라 이미지를 컷팅하는 함수
    
    
    
}
