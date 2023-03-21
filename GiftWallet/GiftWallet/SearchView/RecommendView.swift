//
//  RecommendView.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/07.
//

import UIKit

class RecommendView: UIView {
    //TODO: Title 임시 Text 삭제
    let firstRecommendButton = UIButton(title: "상위 1번째")
    let secondRecommendButton = UIButton(title: "상위 2번째")
    let thirdRecommendButton = UIButton(title: "상위 3번째")
    let fourthRecommendButton = UIButton(title: "상위 4번째")
    let fifthRecommendButton = UIButton(title: "상위 5번째")
    
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
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(recommendStackView)
        [firstRecommendButton, secondRecommendButton, thirdRecommendButton, fourthRecommendButton, fifthRecommendButton].forEach(recommendStackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            recommendStackView.topAnchor.constraint(equalTo: self.topAnchor),
            recommendStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recommendStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recommendStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

private extension UIButton {
    convenience init(title: String) {
        self.init()
        self.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        self.setTitle(title, for: .normal)
        self.layer.borderWidth = 1
    }
}
