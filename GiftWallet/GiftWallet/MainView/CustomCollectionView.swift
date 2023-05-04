//
//  CustomCollectionView.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class CustomCollectionView: UICollectionView {
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewFlowLayout)
        setupAttributes()
        setupContentInsetForCantScrollRightSideContents()
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
    
    private func setupContentInsetForCantScrollRightSideContents() {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        self.contentInset = inset
    }
    
}
