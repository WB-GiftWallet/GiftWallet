//
//  BarcodeViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/14.
//

import UIKit

class BarcodeViewController: UIViewController {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        viewModel.loadOriginBrightness(UIScreen.main.brightness)
        configureImageView()
        setupNavigation()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUISetting(screen: .barcodeScene)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupUISetting(screen: .originScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        viewModel.detectBarcodeInGiftImage { pngData in
            guard let pngData = pngData else { return }
            self.imageView.image = UIImage(data: pngData)
        }
    }
    
    private func setupUISetting(screen: UISetting) {
        lotateScreen(screen)
        changeBrightness(screen)
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

// MARK: Screen Setting 메서드
extension BarcodeViewController {
    private func lotateScreen(_ screen: UISetting) {
        switch screen {
        case .originScene:
            appDelegate.shouldSupportAllOrientation = false
        case .barcodeScene:
            appDelegate.shouldSupportAllOrientation = true
        }
    }
    
    private func changeBrightness(_ screen: UISetting) {
        switch screen {
        case .originScene:
            UIScreen.main.brightness = viewModel.originBrightness
        case .barcodeScene:
            UIScreen.main.brightness = 1.0
        }
    }
}
