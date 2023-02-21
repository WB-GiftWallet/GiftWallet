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
        
    private let memoTextField: UITextField = {
        let textField = UITextField()
        
        textField.font = .preferredFont(forTextStyle: .title2)
        textField.borderStyle = .roundedRect
        textField.placeholder = "메모입력란입니다."
        
        return textField
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
    
    private var isUseableGift = true
    
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
            giftImageView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        giftImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
    }
    
    @objc private func tapSeletedButton() {
        //TODO: Seleted Button Tapped
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "아니요", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(cancel)
        
        if isUseableGift {
            alert.title = "사용 완료 처리할까요?"
            let done = UIAlertAction(title: "네", style: .default) { _ in
                self.changeGiftState(true)
            }
            alert.addAction(done)
        } else {
            alert.title = "사용 가능한 기프티콘인가요?"
            let done = UIAlertAction(title: "네", style: .default) { _ in
                self.changeGiftState(false)
            }
            alert.addAction(done)
        }
        
        present(alert, animated: true)
    }
    
    //TODO: 사용불가, 가능 변경
    private func changeGiftState(_ seleted: Bool) {
        isUseableGift.toggle()
        
        if seleted {
            selectedButton.backgroundColor = .systemGray
        } else {
            selectedButton.backgroundColor = .systemPurple
        }
        dismiss(animated: true)
    }
    
    //TODO: ImageView Tapped
    @objc private func tapImageView(sender: UITapGestureRecognizer) {
        guard let image = giftImageView.image else { return }
        
        present(GiftImageViewController(image: image), animated: true)
    }
}
