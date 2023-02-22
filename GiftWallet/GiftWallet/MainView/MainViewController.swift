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
    
    private let contentScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return UIView()
    }()
    
    
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
        
        imageView.image = UIImage(named: "testImagewoongPhoto")
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
        
        return stackView
    }()
    
    private let expireCollectionViewHeaderLabel = {
        let label = UILabel()
        
        label.text = "😟 기간이 얼마 안남았어요!"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var expireCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private let recentCollectionViewHeaderLabel = {
        let label = UILabel()
        
        label.text = "😄 최근에 등록했어요."
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var recentCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private let expireVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let recentVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        return stackView
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.clipsToBounds = true
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
        [expireCollectionViewHeaderLabel, expireCollectionView].forEach(expireVerticalStackView.addArrangedSubview(_:))
        [recentCollectionViewHeaderLabel, recentCollectionView].forEach(recentVerticalStackView.addArrangedSubview(_:))
        
        contentScrollView.addSubview(contentView)
        [userInfoHorizontalStackView, expireVerticalStackView, recentVerticalStackView].forEach(contentView.addSubview(_:))
        view.addSubview(contentScrollView)
        
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo:
                                                    contentScrollView.heightAnchor),
            
            userInfoHorizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userInfoHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userInfoHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            expireVerticalStackView.topAnchor.constraint(equalTo: userInfoHorizontalStackView.bottomAnchor, constant: 10),
            expireVerticalStackView.leadingAnchor.constraint(equalTo: userInfoHorizontalStackView.leadingAnchor),
            expireVerticalStackView.trailingAnchor.constraint(equalTo: userInfoHorizontalStackView.trailingAnchor),
            
            recentVerticalStackView.topAnchor.constraint(equalTo: expireVerticalStackView.bottomAnchor, constant: 10),
            recentVerticalStackView.leadingAnchor.constraint(equalTo: expireVerticalStackView.leadingAnchor),
            recentVerticalStackView.trailingAnchor.constraint(equalTo: expireVerticalStackView.trailingAnchor),
            recentVerticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            // constraint만 다시잡으면 될듯함.
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
