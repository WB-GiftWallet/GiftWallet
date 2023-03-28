//
//  RecommendView.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/07.
//

import UIKit

class RecommendScrollView: UIScrollView {
    let firstRecommendButton = UIButton()
    let secondRecommendButton = UIButton()
    let thirdRecommendButton = UIButton()
    let fourthRecommendButton = UIButton()
    let fifthRecommendButton = UIButton()
    
    let contentsView = UIView()
    
    let recommendStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        [firstRecommendButton,
         secondRecommendButton,
         thirdRecommendButton,
         fourthRecommendButton,
         fifthRecommendButton].forEach {
            $0.layer.cornerRadius = $0.frame.height/2
            $0.setTitleColor(.systemGray2, for: .normal)
            $0.layer.borderColor = UIColor.systemGray2.cgColor
            $0.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
            $0.layer.borderWidth = 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.showsHorizontalScrollIndicator = false
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
        self.addSubview(contentsView)
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        contentsView.addSubview(recommendStackView)
        
        NSLayoutConstraint.activate([
            recommendStackView.topAnchor.constraint(equalTo: contentsView.topAnchor),
            recommendStackView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            recommendStackView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            recommendStackView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),
            
            contentsView.heightAnchor.constraint(equalTo: self.heightAnchor),
            contentsView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor)
        ])
    }
}
