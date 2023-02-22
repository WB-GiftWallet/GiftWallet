//
//  GiftImageViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

final class GiftImageViewController: ViewController{
    let giftImageView = UIImageView()
    
    init(image: UIImage) {
        self.giftImageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = giftImageView
    }
}

