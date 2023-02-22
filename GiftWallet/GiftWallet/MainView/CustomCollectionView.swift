//
//  CustomCollectionView.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class CustomCollectionView: UICollectionView {
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewFlowLayout)
        setupAttributes()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        collectionViewFlowLayout.scrollDirection = .horizontal
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(MainCollectionViewCell.self,
                      forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
    }
    
    
}
