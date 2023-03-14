//
//  BarcodeViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import UIKit

class BarcodeViewController: UIViewController {

    private let viewModel: BarcodeViewModel

    private let imageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(viewModel: BarcodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.detectBarcodeInGiftImage { image in
            self.imageView.image = image
        }
        setupNavigation()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.lotateScreen(of: .barcode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.lotateScreen(of: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissViewControlelr))
    }
    
    @objc
    private func dismissViewControlelr() {
        dismiss(animated: false, completion: nil)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
}
