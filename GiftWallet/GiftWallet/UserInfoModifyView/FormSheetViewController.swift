//
//  FormSheetViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/22.
//

import UIKit

class FormSheetViewController: UIViewController {
    
    private let contentView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let defaultLabel = {
        let label = UILabel()
        
        label.text = """
입력방법을 선택해주세요.
"""
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let photoImageButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let photoImageViewDescriptionLabel = {
        let label = UILabel()
        
        label.text = "갤러리"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButton()
    }
    
    private func setupButton() {
        let photoAction = UIAction { [weak self] _ in
            print("사진으로 이동")
        }
        photoImageButton.addAction(photoAction, for: .touchUpInside)
        
    }
    
    private func setupViews() {
        
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        [defaultLabel, photoImageButton, photoImageViewDescriptionLabel].forEach(contentView.addSubview(_:))
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            
            defaultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            defaultLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            
            photoImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageButton.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 50),
            photoImageButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            photoImageButton.heightAnchor.constraint(equalTo: photoImageButton.widthAnchor),
            
            photoImageViewDescriptionLabel.topAnchor.constraint(equalTo: photoImageButton.bottomAnchor, constant: 30),
            photoImageViewDescriptionLabel.centerXAnchor.constraint(equalTo: photoImageButton.centerXAnchor)
        ])
    }
}

extension FormSheetViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        
        if !view.subviews.contains(where: { $0.frame.contains(touchLocation) }) {
            self.dismiss(animated: true)
        }
    }
}
