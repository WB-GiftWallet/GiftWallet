//
//  DetailViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let brand: UILabel = {
        let label = UILabel()
        
        label.text = "스타벅스 커피"
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        
        label.text = "아이스 아메리카노 (tall)"
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let dateDueTo: UILabel = {
        let label = UILabel()
        
        label.text = "2024. 04. 14 까지"
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "메모입력란입니다."
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let selectedButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("사용 완료", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.addTarget(nil, action: #selector(tapSeletedButton), for: .touchUpInside)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "tempImages")
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(contentsView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let contentViewHeight = contentsView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        [brand, productName, dateDueTo, memoLabel, selectedButton, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentsView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            brand.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 10),
            brand.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            brand.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),

            productName.topAnchor.constraint(equalTo: brand.bottomAnchor, constant: 10),
            productName.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            productName.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),

            dateDueTo.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 5),
            dateDueTo.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            dateDueTo.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),

            memoLabel.topAnchor.constraint(equalTo: dateDueTo.bottomAnchor, constant: 10),
            memoLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            memoLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),
            
            selectedButton.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: 20),
            selectedButton.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            selectedButton.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),
            selectedButton.heightAnchor.constraint(equalToConstant: view.frame.height / 20),

            imageView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: view.frame.width / 20),
            imageView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let aaa = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(aaa)
    }
    
    @objc func tapImageView(sender: UITapGestureRecognizer) {
        //TODO: ImageView Tapped
    }
    
    @objc func tapSeletedButton() {
        //TODO: Seleted Button Tapped
    }
}
