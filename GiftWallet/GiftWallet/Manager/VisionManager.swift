//
//  VisionManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import UIKit
import Vision

struct VisionManager {
    
    func vnRecognizeRequest() {
        guard let cgImage = UIImage(named: "testImageSTARBUCKSSMALL")?.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLanguages = ["ko_KR"]

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        print(recognizedStrings)
    }
}
