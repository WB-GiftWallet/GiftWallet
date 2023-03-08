//
//  PagingCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let containterView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews() {
        scrollView.addSubview(containterView)
        [].forEach(containterView.addSubview(_:))
        contentView.addSubview(scrollView)
        
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
            containterView.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor),
            containterView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor)
        ])
    }
    
}
