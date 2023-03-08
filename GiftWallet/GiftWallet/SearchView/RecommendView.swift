//
//  RecommendView.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/07.
//

import UIKit

class RecommendView: UIView {
    
    let firstRecommendButton: UIButton = {
        let button = UIButton()
        
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitle("상위 1번째", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let secondRecommendButton: UIButton = {
        let button = UIButton()
        
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitle("상위 2번째", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let thirdRecommendButton: UIButton = {
        let button = UIButton()
        
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitle("상위 3번째", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let fourthRecommendButton: UIButton = {
        let button = UIButton()
        
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitle("상위 4번째", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let fifthRecommendButton: UIButton = {
        let button = UIButton()
        
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitle("상위 5번째", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let recommendStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(recommendStackView)
        [firstRecommendButton, secondRecommendButton, thirdRecommendButton, fourthRecommendButton, fifthRecommendButton].forEach(recommendStackView.addArrangedSubview(_:))
        [firstRecommendButton, secondRecommendButton, thirdRecommendButton, fourthRecommendButton, fifthRecommendButton].forEach {
            $0.setTitleColor(.label, for: .normal)
        }
        
        NSLayoutConstraint.activate([
            recommendStackView.topAnchor.constraint(equalTo: self.topAnchor),
            recommendStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recommendStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recommendStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}


//sort manger 정의하면 좋을듯?
