//
//  DeleteSheetViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/21.
//

import UIKit

class DeleteSheetViewController: UIViewController {
    
    private let viewModel: DeleteSheetViewModel
    private var giftImageViewHeightConstraint: NSLayoutConstraint?
    
    private let giftImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "testImageSTARBUCKSSMALL")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    init(viewModel: DeleteSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureImageView()
        configureGiftImageViewHeightConstraint(size: viewModel.giftImageSize)
    }
    
    private func configureImageView() {
        giftImageView.image = viewModel.gift.image
    }
    
    private func configureGiftImageViewHeightConstraint(size: CGSize) {
        let imageRatio = size.height / size.width
        let imageHeight = view.frame.width * imageRatio
        
        giftImageViewHeightConstraint?.constant = imageHeight
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
        
        view.addSubview(giftImageView)
        
        NSLayoutConstraint.activate([
            giftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            giftImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
        
        giftImageViewHeightConstraint = giftImageView.heightAnchor.constraint(equalToConstant: .zero)
        
        NSLayoutConstraint.activate([
            giftImageViewHeightConstraint
        ].compactMap({ $0 })
        )}
}
