//
//  BarcodeViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import Foundation
import UIKit

class BarcodeViewModel {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let visionManager = VisionManager()
    var gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
    }
    
    func detectBarcodeInGiftImage(completion: @escaping (UIImage?) -> Void) {
        visionManager.detectBarcode(in: gift.image, completion: completion)
    }
    
    func lotateScreen(of direction: ScreenLotation) {
        switch direction {
        case .normal:
            appDelegate.shouldSupportAllOrientation = false
        case .barcode:
            appDelegate.shouldSupportAllOrientation = true
        }        
    }
}

enum ScreenLotation {
    case normal
    case barcode
}
