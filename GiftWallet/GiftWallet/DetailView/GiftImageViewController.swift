//
//  GiftImageViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

final class GiftImageViewController: UIViewController {
    
    private let viewModel: GiftImageViewModel
    
    let giftImageView = UIImageView()
    
    init(viewModel: GiftImageViewModel) {
        self.viewModel = viewModel
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

