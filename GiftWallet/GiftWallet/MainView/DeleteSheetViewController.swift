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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let deleteButton = {
       let button = UIButton()
        
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(style: .regular, size: 18)
        button.addTarget(nil, action: #selector(tapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        deleteButton.layer.cornerRadius = 10
    }
    
    @objc
    private func tapDeleteButton() {
        self.dismiss(animated: true)
    }
    
    private func configureImageView() {
        giftImageView.image = viewModel.gift.image
    }
    
    private func configureGiftImageViewHeightConstraint(size: CGSize) {
        let imageRatio = size.height / size.width
        let imageHeight = view.frame.width * 0.8 * imageRatio
        
        giftImageViewHeightConstraint?.constant = imageHeight
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
                
        [giftImageView, deleteButton].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            giftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            giftImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            deleteButton.topAnchor.constraint(equalTo: giftImageView.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: giftImageView.leadingAnchor),
            deleteButton.widthAnchor.constraint(equalTo: giftImageView.widthAnchor, multiplier: 0.7),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 0.2)
        ])
        
        giftImageViewHeightConstraint = giftImageView.heightAnchor.constraint(equalToConstant: .zero)
        
        NSLayoutConstraint.activate([
            giftImageViewHeightConstraint
        ].compactMap{ $0 })
    }
}
