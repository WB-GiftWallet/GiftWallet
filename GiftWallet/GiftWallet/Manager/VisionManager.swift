//
//  VisionManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import UIKit
import Vision

// MARK: 이미지에서 String을 추출해서 반환하는 함수
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

// MARK: 이미지에서 바코드 영역을 CGRect로 반환해주는 나타내주는 함수 관련
extension VisionManager {
    func detectBarcode(in image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        let request = VNDetectBarcodesRequest { request, error in
            recognizeBarcodeImageHandler(cgImage: cgImage, request: request, error: error, completion: completion)
        }
        
        do {
            try handler.perform([request])
        } catch {
            completion(nil)
        }
    }
    
    private func recognizeBarcodeImageHandler(cgImage: CGImage,
                                              request: VNRequest,
                                              error: Error?,
                                              completion: @escaping (UIImage?) -> Void) {
        guard error == nil else {
            completion(nil)
            return
        }
        
        guard let observations = request.results as? [VNBarcodeObservation],
              let observation = observations.first else {
            completion(nil)
            return
        }
        
        let boundingBox = observation.boundingBox
        let size = CGSize(width: boundingBox.width * CGFloat(cgImage.width),
                          height: boundingBox.height * CGFloat(cgImage.height))
        let origin = CGPoint(x: boundingBox.minX * CGFloat(cgImage.width),
                             y: (1 - boundingBox.maxY) * CGFloat(cgImage.height))
        let rect = CGRect(origin: origin, size: size)
        
        if let croppedCgImage = cgImage.cropping(to: rect) {
            let croppedUIImage = UIImage(cgImage: croppedCgImage)
            completion(croppedUIImage)
        }
    }
    
}

