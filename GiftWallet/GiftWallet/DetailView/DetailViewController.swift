//
//  DetailViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

final class DetailViewController: UIViewController {
        
    private let viewModel: DetailViewModel
    
    private let pagingCollectionView = {
       let collectionView = UICollectionView()
        
        collectionView.register(PagingCollectionViewCell.self,
                                forCellWithReuseIdentifier: PagingCollectionViewCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let dateDueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        
        return label
    }()
        
    private let memoTextField: UITextField = {
        let textField = UITextField()
        
        textField.font = .preferredFont(forTextStyle: .title2)
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let selectedButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("사용 완료", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.addTarget(nil,
                         action: #selector(tapSeletedButton),
                         for: .touchUpInside)
        
        return button
    }()
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageTapGesture()
        setupNavigation()
        setupViews()
        configureGiftData()
    }
    
    private func configureGiftData() {
        brandLabel.text = viewModel.brandName
        productNameLabel.text = viewModel.productName
        dateDueLabel.text = viewModel.expirdDate
        memoTextField.text = viewModel.memo
        giftImageView.image = viewModel.gift.image
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureImageTapGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
        
        giftImageView.isUserInteractionEnabled = true
        giftImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func tapSeletedButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "사용 완료 처리할까요?"
        
        let cancel = UIAlertAction(title: "아니요", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        let done = UIAlertAction(title: "네", style: .default) { _ in
            self.doneAction()
        }

        [cancel, done].forEach(alert.addAction(_:))
        present(alert, animated: true)
    }
    
    private func doneAction() {
        changeGiftState()
        viewModel.writeMemo(memoTextField.text)
        viewModel.coreDataUpdate()
    }
    
    private func changeGiftState() {
        viewModel.toggleToUnUsableState()
        selectedButton.backgroundColor = .systemGray
        dismiss(animated: true)
    }
        
    @objc private func tapImageView(sender: UITapGestureRecognizer) {
        let gift = viewModel.gift
        
        let viewModel = GiftImageViewModel(gift: gift)
        let giftImageViewController = GiftImageViewController(viewModel: viewModel)
        giftImageViewController.modalPresentationStyle = .fullScreen
        present(giftImageViewController, animated: true)
    }
    
}

// MARK: AutoLayout 관련 메서드
extension DetailViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
//        configureScrollView()
//        configureContentView()
//        configureInnerContents()
        
        view.addSubview(pagingCollectionView)
        
        NSLayoutConstraint.activate([
            pagingCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            pagingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    private func configureInnerContents() {
        [brandLabel, productNameLabel, dateDueLabel, memoTextField, selectedButton, giftImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentsView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 10),
            brandLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            brandLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),

            productNameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            productNameLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),

            dateDueLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            dateDueLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            dateDueLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),

            memoTextField.topAnchor.constraint(equalTo: dateDueLabel.bottomAnchor, constant: 10),
            memoTextField.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            memoTextField.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),
            
            selectedButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 20),
            selectedButton.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            selectedButton.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),
            selectedButton.heightAnchor.constraint(equalToConstant: view.frame.height / 20),

            giftImageView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: view.frame.width / 20),
            giftImageView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            giftImageView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            giftImageView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),
            giftImageView.heightAnchor.constraint(lessThanOrEqualTo: giftImageView.widthAnchor, multiplier: 2)
        ])
    }
}
