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
