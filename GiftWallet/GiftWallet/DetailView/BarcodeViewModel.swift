//
//  BarcodeViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import Foundation
import UIKit

class BarcodeViewModel {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let visionManager = VisionManager()
    private var screenBrightness: CGFloat = 1.0
    
    var gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
    }
    
    var brightness: CGFloat {
        return screenBrightness
    }
    
    func detectBarcodeInGiftImage(completion: @escaping (UIImage?) -> Void) {
        visionManager.detectBarcode(in: gift.image, completion: completion)
    }
    
    func lotateScreen(of direction: UISetting) {
        switch direction {
        case .originScene:
            appDelegate.shouldSupportAllOrientation = false
        case .barcodeScene:
            appDelegate.shouldSupportAllOrientation = true
        }        
    }
    
    func loadOriginBrightness(_ value: CGFloat) {
        screenBrightness = value
    }
}

enum UISetting {
    case originScene
    case barcodeScene
}
