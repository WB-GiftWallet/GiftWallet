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
    
    private lazy var contentScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private let viewModel: MainViewModel
    
    private let userNameLabel = {
        let label = UILabel()
        
        label.text = Constant.userNameDescription
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let userInfoModifyButton = {
        let button = UIButton()
        
        button.setTitle(Constant.updateUserInfoDescription, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let expireCollectionViewHeaderLabel = {
        let label = UILabel()
        
        label.text = "😟 기간이 얼마 안남았어요!"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var expireCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let recentCollectionViewHeaderLabel = {
        let label = UILabel()
        
        label.text = "😄 최근에 등록했어요."
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var recentCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        
        collectionView.collectionViewFlowLayout.scrollDirection = .horizontal
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private let expireVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let recentVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        setupProfileButton()
        setupViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchCoreData()
        viewModel.sortOutInGlobalThread()
    }
    
    private func bind() {
        viewModel.expireGifts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.expireCollectionView.reloadData()
            }
        }
        
        viewModel.recentGifts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.recentCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.clipsToBounds = true
    }
    
    private func setupProfileButton() {
        let modifyAction = UIAction { [weak self] _ in
            let userInfoModifyViewModel = UserInfoModifyViewModel()
            let userInfoModifyViewController = UserInfoModifyViewController(userInfoModifyViewModel: userInfoModifyViewModel)
            self?.navigationController?.pushViewController(userInfoModifyViewController, animated: true)
        }
        userInfoModifyButton.addAction(modifyAction, for: .touchUpInside)
    }
    
    private func setupViews() {

        [userNameLabel, userInfoModifyButton].forEach(userInfoVerticalStackView.addArrangedSubview(_:))
        [userInfoVerticalStackView, userProfileImageView].forEach(userInfoHorizontalStackView.addArrangedSubview(_:))
        
        contentView.addSubview(userInfoHorizontalStackView)
        contentView.addSubview(expireCollectionViewHeaderLabel)
        contentView.addSubview(expireCollectionView)
        contentView.addSubview(recentCollectionViewHeaderLabel)
        contentView.addSubview(recentCollectionView)
        
        contentScrollView.addSubview(contentView)
        view.addSubview(contentScrollView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor),
            
            userProfileImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            userProfileImageView.heightAnchor.constraint(equalTo: userProfileImageView.widthAnchor),
            
            userInfoHorizontalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            userInfoHorizontalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            userInfoHorizontalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            
            expireCollectionViewHeaderLabel.topAnchor.constraint(equalTo: userInfoHorizontalStackView.bottomAnchor, constant: 30),
            expireCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            
            expireCollectionView.topAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.bottomAnchor, constant: 5),
            expireCollectionView.leadingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.leadingAnchor),
            expireCollectionView.trailingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.trailingAnchor),
            expireCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            expireCollectionView.heightAnchor.constraint(equalTo: expireCollectionView.widthAnchor, multiplier: 0.85),
            
            recentCollectionViewHeaderLabel.topAnchor.constraint(equalTo: expireCollectionView.bottomAnchor, constant: 10),
            recentCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.leadingAnchor),
            
            recentCollectionView.topAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.bottomAnchor, constant: 5),
            recentCollectionView.leadingAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.leadingAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.trailingAnchor),
            recentCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            recentCollectionView.heightAnchor.constraint(equalTo: recentCollectionView.widthAnchor, multiplier: 0.85),
            
        ])
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case expireCollectionView:
            return viewModel.expireGifts.value.count
        case recentCollectionView:
            return viewModel.recentGifts.value.count
        default:
            print("테이블뷰데이터소스: 이거문제있음.")
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case expireCollectionView:
            let cell = expireCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? MainCollectionViewCell ?? MainCollectionViewCell()
            let expireGift = viewModel.expireGifts.value[indexPath.row]
            cell.configureCell(data: expireGift)
            return cell
        case recentCollectionView:
            let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? MainCollectionViewCell ?? MainCollectionViewCell()
            let recentGift = viewModel.recentGifts.value[indexPath.row]
            cell.configureCell(data: recentGift)
            return cell
        default:
            print("셀 반환 실패")
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var sendingGiftData: Gift?
        
        switch collectionView {
            case expireCollectionView:
                sendingGiftData = viewModel.expireGifts.value[indexPath.row]
            case recentCollectionView:
                sendingGiftData = viewModel.recentGifts.value[indexPath.row]
            default:
                sendingGiftData = nil
        }
        let detailViewController = DetailViewController(giftData: sendingGiftData)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
