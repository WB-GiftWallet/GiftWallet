//
//  PagingCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell, ReusableView {
    
    var tapElementDelegate: CellElementTappedDelegate?
    var scrollViewDidTopDelegate: CellScrollToTopDelegate?
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
    
    private let modifyButton: UIButton = {
       let button = UIButton()
        
        button.setTitle("정보수정", for: .normal)
        button.titleLabel?.font = UIFont(style: .regular, size: 12)
        button.setTitleColor(.modifyButtonTitle, for: .normal)
        button.layer.borderColor = UIColor.modifyButtonBorder.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    
    
    private let barcodeButton: UIButton = {
       let button = UIButton()
        
        button.setImage(UIImage(named: "barcodeButtonIcon"), for: .normal)
        button.addTarget(nil, action: #selector(tapBarcodeButton), for: .touchUpInside)
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
        button.addTarget(nil, action: #selector(tappedSelectButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.delegate = self
        setupGestureRecognizer()
        setupViews()
        memoTextField.setupTextFieldBottomBorder()
//        modifyButton.layer.cornerRadius = 5

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
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(tapImageView))
        giftImageView.isUserInteractionEnabled = true
        giftImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func tappedSelectButton() {
        guard let indexPath = getIndexPath() else { return }
        
        tapElementDelegate?.tappedUseGiftButton(indexPathRow: indexPath.row, text: memoTextField.text)
    }
    
    @objc private func tapBarcodeButton() {
        guard let indexPath = getIndexPath() else { return }

        tapElementDelegate?.tappedbarcodeButton(indexPathRow: indexPath.row)
    }
    
    @objc private func tapImageView() {
        guard let indexPath = getIndexPath() else { return }

        tapElementDelegate?.tappedImageView(indexPathRow: indexPath.row)
    }
    
    private func getIndexPath() -> IndexPath? {
        guard let collectionView = superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else { return nil }
        
        return indexPath
    }
    
    
    private func setupViews() {
        [brandLabel, productNameLabel, expireDateLabel].forEach(labelVerticalStackView.addArrangedSubview(_:))
        
        scrollView.addSubview(containerView)
        [labelVerticalStackView, modifyButton, barcodeButton, memoTextField, selectedButton, giftImageView].forEach(containerView.addSubview(_:))
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
            
            modifyButton.centerXAnchor.constraint(equalTo: barcodeButton.centerXAnchor),
            modifyButton.centerYAnchor.constraint(equalTo: brandLabel.centerYAnchor),
            modifyButton.widthAnchor.constraint(equalTo: barcodeButton.widthAnchor, multiplier: 1.3),
            modifyButton.heightAnchor.constraint(equalTo: modifyButton.widthAnchor, multiplier: 0.4),
            
            barcodeButton.leadingAnchor.constraint(equalTo: labelVerticalStackView.trailingAnchor, constant: 10),
            barcodeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35),
            barcodeButton.bottomAnchor.constraint(equalTo: labelVerticalStackView.bottomAnchor),
            barcodeButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.13),
            barcodeButton.heightAnchor.constraint(equalTo: barcodeButton.widthAnchor, multiplier: 0.7),
            
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

// MARK: UIScrollViewDelegate 관련
extension PagingCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= .zero {
            scrollViewDidTopDelegate?.scrollViewDidTop()
        }
    }
}

protocol CellElementTappedDelegate {
    func tappedModifyButton(indexPathRow: Int)
    func tappedbarcodeButton(indexPathRow: Int)
    func tappedImageView(indexPathRow: Int)
    func tappedUseGiftButton(indexPathRow: Int, text: String?)
}

protocol CellScrollToTopDelegate {
    func scrollViewDidTop()
}
