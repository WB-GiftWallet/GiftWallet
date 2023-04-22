//
//  AlarmListViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/22.
//

import UIKit

class AlarmListViewController: UIViewController {
    
    let viewModel = AlarmListViewModel()
    
//    var collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "AlarmListView"
        self.view.backgroundColor = .systemPink
        
//        configureLayout()
    }
    
//    func configureLayout() {
//        view.addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
//    }
}
