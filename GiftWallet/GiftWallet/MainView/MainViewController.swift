//
//  MainViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit
import FirebaseAuth
import SkeletonView

class MainViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    private let viewModel: MainViewModel
    
    private var expireCollectionViewHeightAnchor: NSLayoutConstraint?
    private var recentCollectionViewHeightAnchor: NSLayoutConstraint?
    private var recentCollectionHeaderLabelTopAnchor: NSLayoutConstraint?
    
    private lazy var contentScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emptyImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "camera")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .modifyButtonBorder
        
        return imageView
    }()
    
    private let emptyLabel = {
        let label = UILabel()
        
        label.text = "내 쿠폰함"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(style: .bold, size: 20)
        
        return label
    }()
    
    private let emptyDescriptionLabel = {
        let label = UILabel()
        
        label.text = "쿠폰을 등록하면 쿠폰함에 표시됩니다."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .modifyButtonTitle
        label.font = UIFont(style: .regular, size: 18)
        
        return label
    }()
    
    private let emptyVerticalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isHidden = true
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var searchButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9, height: view.frame.height * 0.04))
        button.backgroundColor = .serachButton
        button.setTitle("    브랜드로 검색하기", for: .normal)
        button.titleLabel?.font = UIFont(style: .medium, size: 16)
        button.setTitleColor(UIColor.searchLabel, for: .normal)
        button.contentHorizontalAlignment = .left
//        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .searchLabel
//        button.semanticContentAttribute = .forceRightToLeft
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - button.frame.width * 0.55, bottom: 0, right: 0)
        button.layer.cornerRadius = 6
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let buttonImageView = {
       let imageView = UIImageView()
        
        imageView.tintColor = .searchLabel
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    private let expireCollectionViewHeaderLabel = {
        let label = UILabel()
        
        label.text = "😟 기간이 얼마 안남았어요"
        label.font = UIFont(style: FontStyle.bold, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        label.text = "😄 최근에 등록했어요"
        label.font = UIFont(style: FontStyle.bold, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        setupViews()
        setupButton()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentLoginViewIfNeeded()
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
    
    private func presentLoginViewIfNeeded() {
        viewModel.checkIfUserLoggedIn {
            self.setupViewSkeletonable(true)
            
            let loginViewModel = LoginViewModel()
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            loginViewController.delegate = self
            loginViewController.modalPresentationStyle = .overFullScreen
            self.present(loginViewController, animated: false)
        } completionWhenUserIsLoggedIn: {
            self.updateCollectionViewData()
        }
    }
    
    private func setupViewSkeletonable(_ bool: Bool) {
        let target = [searchButton, expireCollectionViewHeaderLabel, recentCollectionViewHeaderLabel ,expireCollectionView, recentCollectionView]
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .bottomRightTopLeft)
        
        target.forEach { $0.isSkeletonable = true }
        
        if bool {
            target.forEach { $0.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .clouds), animation: skeletonAnimation, transition: .crossDissolve(0.25)) }
        } else {
            target.forEach { $0.hideSkeleton() }
        }
    }
    
    private func updateCollectionViewData() {
        viewModel.fetchCoreData()
        viewModel.sortOutInGlobalThread {
            self.resizeViewsAutoLayoutBasedOnGiftsData()
        }
    }
    
    private func setupButton() {
        let searchButtonAction = UIAction { [weak self] _ in            
            let gifts = self.viewModel.recentGifts.value + self.viewModel.expireGifts.value
            let observableGifts: Observable<[Gift]> = .init(gifts)
            let searchTableViewModel = SearchTableViewModel(allGiftData: observableGifts)
            let searchViewController = SearchViewController(viewModel: searchTableViewModel)
            self.navigationController?.pushViewController(searchViewController, animated: true)
        }
        searchButton.addAction(searchButtonAction, for: .touchUpInside)
    }
    
    private func setupViews() {
        
        searchButton.addSubview(buttonImageView)
        [emptyImageView, emptyLabel, emptyDescriptionLabel].forEach(emptyVerticalStackView.addArrangedSubview(_:))
        contentView.addSubview(emptyVerticalStackView)
        
        contentView.addSubview(searchButton)
        contentView.addSubview(expireCollectionViewHeaderLabel)
        contentView.addSubview(expireCollectionView)
        contentView.addSubview(recentCollectionViewHeaderLabel)
        contentView.addSubview(recentCollectionView)
        
        contentScrollView.addSubview(contentView)
        view.addSubview(contentScrollView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            buttonImageView.widthAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 0.06),
            buttonImageView.heightAnchor.constraint(equalTo: buttonImageView.widthAnchor, multiplier: 1),
            buttonImageView.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: -10),
            buttonImageView.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
        
            emptyVerticalStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyVerticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            emptyVerticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyVerticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor, multiplier: 1.3),
            
            searchButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            searchButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            searchButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.04),
            
            expireCollectionViewHeaderLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 30),
            expireCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            
            expireCollectionView.topAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.bottomAnchor, constant: 15),
            expireCollectionView.leadingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.leadingAnchor),
            expireCollectionView.trailingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.trailingAnchor),
            expireCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            recentCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.leadingAnchor),
            
            recentCollectionView.topAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.bottomAnchor, constant: 15),
            recentCollectionView.leadingAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.leadingAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.trailingAnchor),
            recentCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        setupResponsiveConstraintViews()
    }
    
    private func setupResponsiveConstraintViews() {
        expireCollectionViewHeightAnchor = expireCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.95)
        recentCollectionViewHeightAnchor = recentCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.95)
        recentCollectionHeaderLabelTopAnchor = recentCollectionViewHeaderLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: view.frame.height * 0.60)
        
        NSLayoutConstraint.activate([
            expireCollectionViewHeightAnchor,
            recentCollectionViewHeightAnchor,
            recentCollectionHeaderLabelTopAnchor
        ].compactMap { $0 })
    }
    
    private func resizeViewsAutoLayoutBasedOnGiftsData() {
        let expireGifts = viewModel.expireGifts.value
        let recentGifts = viewModel.recentGifts.value
        
        switch (expireGifts.isEmpty, recentGifts.isEmpty) {
        case (true, true):
            updateConstantBasedOnViewActivation(emptyViewActivate: true, expireCollectionViewActivate: false,
                                                recentCollectionViewActivate: false, recentHeaderLabelActivate: false)
        case (true, false):
            updateConstantBasedOnViewActivation(emptyViewActivate: false, expireCollectionViewActivate: false,
                                                recentCollectionViewActivate: true, recentHeaderLabelActivate: false)
        case (false, true):
            updateConstantBasedOnViewActivation(emptyViewActivate: false, expireCollectionViewActivate: true,
                                                recentCollectionViewActivate: false, recentHeaderLabelActivate: false)
        case (false, false):
            updateConstantBasedOnViewActivation(emptyViewActivate: false, expireCollectionViewActivate: true,
                                                recentCollectionViewActivate: true, recentHeaderLabelActivate: true)
        }
    }
    
    private func updateConstantBasedOnViewActivation(emptyViewActivate: Bool, expireCollectionViewActivate: Bool,
                                                     recentCollectionViewActivate: Bool, recentHeaderLabelActivate: Bool) {
        emptyVerticalStackView.isHidden = emptyViewActivate ? false : true
        
        expireCollectionViewHeaderLabel.isHidden = expireCollectionViewActivate ? false : true
        recentCollectionViewHeaderLabel.isHidden = recentCollectionViewActivate ? false : true
        
        expireCollectionViewHeightAnchor?.constant = expireCollectionViewActivate ? view.frame.width * 0.95 : 0
        recentCollectionViewHeightAnchor?.constant = recentCollectionViewActivate ? view.frame.width * 0.95 : 0
        recentCollectionHeaderLabelTopAnchor?.constant = recentHeaderLabelActivate ? view.frame.height * 0.60 : 25
        
        expireCollectionView.layoutIfNeeded()
        recentCollectionView.layoutIfNeeded()
        recentCollectionViewHeaderLabel.layoutIfNeeded()
    }
}

// MARK: UIColellectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
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
            let subtractionResult = viewModel.subtractionOfDays(expireDate: expireGift.expireDate)
            
            cell.configureCell(data: expireGift)
            cell.configureTagLabel(subtractionResult)
            return cell
            
        case recentCollectionView:
            let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? MainCollectionViewCell ?? MainCollectionViewCell()
            let recentGift = viewModel.recentGifts.value[indexPath.row]
            
            cell.configureCell(data: recentGift)
            cell.setupTagViewIsHidden()
            return cell
        default:
            print("셀 반환 실패")
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var sendGifts: [Gift]?
        
        switch collectionView {
        case expireCollectionView:
            sendGifts = viewModel.expireGifts.value
        case recentCollectionView:
            sendGifts = viewModel.recentGifts.value
        default:
            break
        }
        guard let sendGifts = sendGifts else { return }
        let detailViewModel = DetailViewModel(gifts: sendGifts,
                                              indexPahtRow: indexPath.row)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.delegate = self
        let navigationDetailViewController = UINavigationController(rootViewController: detailViewController)
        navigationDetailViewController.modalTransitionStyle = .coverVertical
        navigationDetailViewController.modalPresentationStyle = .overFullScreen
        
        present(navigationDetailViewController, animated: true)
    }
}

// MARK: UICollectionViewDelegate 관련 ( ContextMenu )
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let gift = getGift(for: collectionView, indexPath: indexPath) else { return nil }
        let identifier = indexPath.row as NSNumber
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
            return PhotoPreviewViewController(image: gift.image)
        }, actionProvider: { _ in
            return self.makeMenu(gift: gift, collectionView: collectionView)
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let index = configuration.identifier as? Int else { return nil }
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell else { return nil }
        
        return UITargetedPreview(view: cell.giftImageView)
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            guard let index = configuration.identifier as? Int else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let gift = self.getGift(for: collectionView, indexPath: indexPath) else { return }
            
            self.seeAction(gift: gift)
        }
    }
    
    private func getGift(for collectionView: UICollectionView, indexPath: IndexPath) -> Gift? {
        let gift: Gift?
        
        switch collectionView {
        case expireCollectionView:
            gift = viewModel.expireGifts.value[indexPath.row]
        case recentCollectionView:
            gift = viewModel.recentGifts.value[indexPath.row]
        default:
            gift = nil
        }
        return gift
    }
    
    private func makeMenu(gift: Gift, collectionView: UICollectionView) -> UIMenu {
        let see = UIAction(title: "보기", image: UIImage(systemName: "magnifyingglass")) { action in
            self.seeAction(gift: gift)
        }
        
        
        let modify = UIAction(title: "수정하기", image: UIImage(systemName: "square.and.pencil")) { action in
            self.modifyAction(gift: gift)
        }
        
        let completeUse = UIAction(title: "사용완료", image: UIImage(systemName: "checkmark.circle")) { action in
            self.completeUseAction(gift: gift)
        }
        
        let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.deleteAction(gift: gift)
        }
        
        return UIMenu(title: "", children: [see, modify, completeUse, delete])
    }
    
    private func seeAction(gift: Gift) {
        let gifts = [gift]
        let viewModel = DetailViewModel(gifts: gifts)
        let detailViewController = DetailViewController(viewModel: viewModel)
        detailViewController.delegate = self
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.modalPresentationStyle = .overFullScreen
        self.present(detailViewController, animated: true)
    }
    
    private func modifyAction(gift: Gift) {
        let updateViewModel = UpdateViewModel(gift: gift)
        let updateGiftInfoViewController = UpdateGiftInfoViewController(viewModel: updateViewModel)
        let navigationUpdateGiftInfoViewController = UINavigationController(rootViewController: updateGiftInfoViewController)
        navigationUpdateGiftInfoViewController.modalPresentationStyle = .fullScreen
        self.present(navigationUpdateGiftInfoViewController, animated: true)
    }
    
    private func completeUseAction(gift: Gift) {
        let alertController = UIAlertController(title: nil, message: "선택한 쿠폰을 사용완료로 처리합니다.",
                                                preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            self.viewModel.updateGiftUsableState(updategiftNumber: gift.number)
            self.updateCollectionViewData()
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
    
    private func deleteAction(gift: Gift) {
        let alertController = UIAlertController(title: nil, message: "선택한 쿠폰을 완전히 제거합니다.", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            self.viewModel.deleteCoreData(targetGiftNumber: gift.number)
            self.viewModel.deleteFirebaseStoreDocument(targetGiftNumber: gift.number)
            self.updateCollectionViewData()
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
}


// MARK: UICollectionViewDelegateFlowLayout 관련
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: Skeleton DataSource
extension MainViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return MainCollectionViewCell.reuseIdentifier
    }
}

// MARK: GiftDidDismissDelegate Protocol 관련
extension MainViewController: GiftDidDismissDelegate {
    func didDismissDetailViewController() {
        updateCollectionViewData()
    }
}

// MARK: DidFetchGiftDelegate Protocol 관련
extension MainViewController: DidFetchGiftDelegate {
    func finishedFetch() {
        setupViewSkeletonable(false)
        updateCollectionViewData()
    }
}
