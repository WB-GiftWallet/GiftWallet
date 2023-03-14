//
//  BarcodeViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import UIKit

class BarcodeViewController: UIViewController {

    private let viewModel: BarcodeViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: BarcodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
