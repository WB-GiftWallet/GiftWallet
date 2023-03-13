//
//  PagingCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell, ReusableView {
    
    var delegate: GiftStateSendable?
    var provider: ScrollViewOffSetProvider?
    private var giftImageViewHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .bold, size: 25)
        
        return label
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .medium, size: 20)
        
        return label
    }()
    
    private let expireDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .light, size: 18)
        
        return label
    }()
    
    private let barcodeButton: UIButton = {
       let button = UIButton()
        
        button.setImage(UIImage(named: "barcodeButtonIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let labelVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let memoTextField: CustomTextField = {
        let textField = CustomTextField(frame: .zero)
        
        textField.placeholder = "메모가 필요하시면 입력해주세요"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let selectedButton: CustomButton = {
        let button = CustomButton()
        
        button.setTitle("사용하기", for: .normal)
        button.addTarget(nil, action: #selector(tappedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc
    func tappedButton() {
        guard let collectionView = superview as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPath(for: self) else { return }
        
        delegate?.sendCellInformation(indexPathRow: indexPath.row, text: memoTextField.text)
    }
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.delegate = self
        setupViews()
        memoTextField.setupTextFieldBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        brandLabel.text = nil
        productNameLabel.text = nil
        expireDateLabel.text = nil
        giftImageView.image = nil
    }
    
    func configureCell(data: Gift) {
        brandLabel.text = data.brandName
        productNameLabel.text = data.productName
        expireDateLabel.text = data.expireDate?.setupDateStyleForDisplay()
        giftImageView.image = data.image
        
        configureGiftImageViewHeightConstraint(size: data.image.size)
    }
    
    private func configureGiftImageViewHeightConstraint(size: CGSize) {
        let imageRatio = size.height / size.width
        let imageHeight = contentView.frame.width * imageRatio

        giftImageViewHeightConstraint?.constant = imageHeight
    }
    
    private func setupViews() {
        [brandLabel, productNameLabel, expireDateLabel].forEach(labelVerticalStackView.addArrangedSubview(_:))
        
        scrollView.addSubview(containerView)
        [labelVerticalStackView, barcodeButton, memoTextField, selectedButton, giftImageView].forEach(containerView.addSubview(_:))
        contentView.addSubview(scrollView)
        
        let contentLayoutGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 3),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor),
            
            labelVerticalStackView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 100),
            labelVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            barcodeButton.leadingAnchor.constraint(equalTo: labelVerticalStackView.trailingAnchor, constant: 10),
            barcodeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35),
            barcodeButton.centerYAnchor.constraint(equalTo: labelVerticalStackView.centerYAnchor),
            barcodeButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.12),
            barcodeButton.heightAnchor.constraint(equalTo: barcodeButton.widthAnchor, multiplier: 0.8),
            
            memoTextField.topAnchor.constraint(equalTo: labelVerticalStackView.bottomAnchor, constant: 30),
            memoTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            memoTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            selectedButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 20),
            selectedButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.05),
            selectedButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            
            giftImageView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: 20),
            giftImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
        ])
        
        giftImageViewHeightConstraint = giftImageView.heightAnchor.constraint(equalToConstant: .zero)
        
        NSLayoutConstraint.activate([
            giftImageViewHeightConstraint
        ].compactMap{ $0 })
        
    }
}

extension PagingCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= .zero {
            provider?.configureIsRequireDismissScene()
        }
    }
}


protocol GiftStateSendable {
    func sendCellInformation(indexPathRow: Int, text: String?)
}

protocol ScrollViewOffSetProvider {
    func configureIsRequireDismissScene()
}
