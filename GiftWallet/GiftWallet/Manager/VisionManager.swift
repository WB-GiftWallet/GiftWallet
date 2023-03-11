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
    func detectBarcode(in image: UIImage, completion: @escaping (CGRect?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        let request = VNDetectBarcodesRequest { request, error in
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
            
            completion(rect)
        }
        
        do {
            try handler.perform([request])
        } catch {
            completion(nil)
        }
    }
    // 2. rect에 따라 이미지를 컷팅하는 함수
    
    
    
}
