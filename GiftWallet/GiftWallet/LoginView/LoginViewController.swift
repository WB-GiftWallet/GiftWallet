//
//  LoginViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/31.
//

import UIKit

class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
