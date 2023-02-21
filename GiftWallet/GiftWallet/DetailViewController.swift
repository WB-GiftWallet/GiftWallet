//
//  DetailViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

final class DetailViewController: UIViewController {
    
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
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        
        label.text = "스타벅스 커피"
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "아이스 아메리카노 (tall)"
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let dateDueLabel: UILabel = {
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
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "tempImages")
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureContentView()
        configureInnerContents()
        
        let aaa = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
        giftImageView.isUserInteractionEnabled = true
        giftImageView.addGestureRecognizer(aaa)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureContentView() {
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
    }
    
    private func configureInnerContents() {
        [brandLabel, productNameLabel, dateDueLabel, memoLabel, selectedButton, giftImageView].forEach {
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

            memoLabel.topAnchor.constraint(equalTo: dateDueLabel.bottomAnchor, constant: 10),
            memoLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            memoLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),
            
            selectedButton.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: 20),
            selectedButton.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: view.frame.width / 20),
            selectedButton.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -view.frame.width / 20),
            selectedButton.heightAnchor.constraint(equalToConstant: view.frame.height / 20),

            giftImageView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: view.frame.width / 20),
            giftImageView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            giftImageView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            giftImageView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        giftImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
    }
    
    @objc func tapImageView(sender: UITapGestureRecognizer) {
        //TODO: ImageView Tapped
        print("Tapped ImageView")
    }
    
    @objc func tapSeletedButton() {
        //TODO: Seleted Button Tapped
        print("Tapped SeletedButton")
    }
}
