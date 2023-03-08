//
//  PagingCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell, ReusableView {
    
    var delegate: GiftStateSendable?
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        return scrollView
    }()
    
    private let containterView: UIView = {
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
        setupViews()
        memoTextField.setupTextFieldBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: Gift) {
        brandLabel.text = data.brandName
        productNameLabel.text = data.productName
        expireDateLabel.text = data.expireDate?.setupDateStyleForDisplay()
        giftImageView.image = data.image
        calculateImageViewSize()
    }
    
    private func setupViews() {
        [brandLabel, productNameLabel, expireDateLabel].forEach(labelVerticalStackView.addArrangedSubview(_:))
        
        scrollView.addSubview(containterView)
        [labelVerticalStackView, memoTextField, selectedButton, giftImageView].forEach(containterView.addSubview(_:))
        contentView.addSubview(scrollView)
        
        let containerViewHeightConstraint = containterView.heightAnchor.constraint(equalTo: giftImageView.heightAnchor, multiplier: 1.6)
            containerViewHeightConstraint.priority = .defaultHigh
        
        let contentLayoutGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containterView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            containterView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            containterView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            containterView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            containterView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerViewHeightConstraint,
            
            labelVerticalStackView.topAnchor.constraint(equalTo: containterView.safeAreaLayoutGuide.topAnchor, constant: 100),
            labelVerticalStackView.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 15),
            labelVerticalStackView.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -15),
            
            memoTextField.topAnchor.constraint(equalTo: labelVerticalStackView.bottomAnchor, constant: 30),
            memoTextField.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 15),
            memoTextField.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -15),
            
            selectedButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 20),
            selectedButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.05),
            selectedButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            
            giftImageView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: 20),
            giftImageView.leadingAnchor.constraint(equalTo: containterView.leadingAnchor),
            giftImageView.trailingAnchor.constraint(equalTo: containterView.trailingAnchor),
            giftImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    //MARK: 작동안되는 셀 발견됨 추후 로직에 대한 수정이 필요하다. (어느 시점에 계산을 해줄 것인지도 고민해봐야함.
    // 현재 생각으로 Usecase에서 이미지의 비율을 계산하는 로직을 구현해서 cell이 configure되기 전에 비율을 갖고 있는 것도 좋아보인다.
    private func calculateImageViewSize() {
        containterView.layoutIfNeeded()
        guard let image = giftImageView.image else { return }
        let imageAspectRatio = image.size.height / image.size.width
        let newImageViewHeight = containterView.frame.width * imageAspectRatio
        
        giftImageView.heightAnchor.constraint(equalToConstant: newImageViewHeight).isActive = true
    }
}

protocol GiftStateSendable {
    func sendCellInformation(indexPathRow: Int, text: String?)
}
