//
//  MainViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    enum Constant {
        static let userNameDescription = """
AAAA 님의
기프티콘 지갑입니다.
"""
        static let updateUserInfoDescription = "정보 수정"
    }
    
    private let viewModel: MainViewModel
        
    private let userNameLabel = {
       let label = UILabel()
        
        label.text = Constant.userNameDescription
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let updateUserInfoButton = {
       let button = UIButton()
        
        button.setTitle(Constant.updateUserInfoDescription, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        
        return button
    }()
    
    private let userProfileImageView = {
       let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "cloud")
        
        return imageView
    }()
    
    private let userInfoVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let userInfoHorizontalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // 헤드라벨 compositionalLayout 구성 후 추가
    private let expireCollectionViewHeaderLabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var expireCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var recentCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    // 헤드라벨 compositionalLayout 구성 후 추가
    private let recentCollectionViewHeaderLabel = {
        let label = UILabel()
        
        return label
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
    }
    
    
    private func setupNavigation() {
        let searchAction = UIAction { _ in
            print("검색창 전환")
        }
        let bellAction = UIAction { _ in
            print("알림리스트로 전환")
        }
        
        let searchSFSymbol = UIImage(systemName: "magnifyingglass")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: searchSFSymbol,
                                                           primaryAction: searchAction)
        let bellSFSymbol = UIImage(systemName: "bell.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: bellSFSymbol,
                                                            primaryAction: bellAction)
        navigationController?.navigationBar.tintColor = .black
    }
        
    private func setupViews() {
        
        [userNameLabel, updateUserInfoButton].forEach(userInfoVerticalStackView.addArrangedSubview(_:))
        [userInfoVerticalStackView, userProfileImageView].forEach(userInfoHorizontalStackView.addArrangedSubview(_:))
        [userInfoHorizontalStackView, expireCollectionView, recentCollectionView].forEach(view.addSubview(_:))
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            userInfoHorizontalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            userInfoHorizontalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            userInfoHorizontalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            userProfileImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.15),
            userProfileImageView.heightAnchor.constraint(equalTo: userProfileImageView.widthAnchor),
            
            expireCollectionView.topAnchor.constraint(equalTo: userInfoHorizontalStackView.bottomAnchor, constant: 10),
            expireCollectionView.leadingAnchor.constraint(equalTo: userInfoHorizontalStackView.leadingAnchor),
            expireCollectionView.trailingAnchor.constraint(equalTo: userInfoHorizontalStackView.trailingAnchor),
            expireCollectionView.widthAnchor.constraint(equalTo: userInfoHorizontalStackView.widthAnchor),
            expireCollectionView.heightAnchor.constraint(equalTo: expireCollectionView.widthAnchor),
            
            recentCollectionView.topAnchor.constraint(equalTo: expireCollectionView.bottomAnchor, constant: 10),
            recentCollectionView.leadingAnchor.constraint(equalTo: expireCollectionView.leadingAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: expireCollectionView.trailingAnchor),
            recentCollectionView.widthAnchor.constraint(equalTo: expireCollectionView.widthAnchor),
            recentCollectionView.heightAnchor.constraint(equalTo: recentCollectionView.widthAnchor)
        ])
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case expireCollectionView:
            return viewModel.expireModel.count
        case recentCollectionView:
            return viewModel.recentModel.count
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case expireCollectionView:
            let cell = expireCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? MainCollectionViewCell ?? MainCollectionViewCell()
            let model = viewModel.expireModel[indexPath.row]
            cell.configureCell(data: model)
            return cell
        case recentCollectionView:
            let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? MainCollectionViewCell ?? MainCollectionViewCell()
            let model = viewModel.recentModel[indexPath.row]
            cell.configureCell(data: model)
            return cell
        default:
            print("셀 반환 실패")
        }
        return UICollectionViewCell()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainViewControllerPreview: PreviewProvider {
    static var previews: some View {
        MainViewController(viewModel: MainViewModel()).showPreview()
    }
}
#endif
