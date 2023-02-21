//
//  CustomCollectionView.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class CustomCollectionView: UICollectionView {
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private let headerLabel = {
       let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewFlowLayout)
        collectionViewFlowLayout.scrollDirection = .horizontal
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributes() {
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
