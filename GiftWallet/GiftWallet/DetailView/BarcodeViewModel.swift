//
//  BarcodeViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import Foundation

class BarcodeViewModel {

    private let visionManager = VisionManager()
    private var screenBrightness: CGFloat = 1.0
    
    var gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
    }
    
    var originBrightness: CGFloat {
        return screenBrightness
    }
    
    func detectBarcodeInGiftImage(completion: @escaping (Data?) -> Void) {
        visionManager.barcodeRecognizeRequest(in: gift.image, completion: completion)
    }
    
    func loadOriginBrightness(_ value: CGFloat) {
        screenBrightness = value
    }
}

enum UISetting {
    case originScene
    case barcodeScene
}
