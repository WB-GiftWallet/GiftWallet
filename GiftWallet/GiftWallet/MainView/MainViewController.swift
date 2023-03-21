//
//  MainViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    private let viewModel: MainViewModel
    
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
    
    private let emptyImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "emptyBoxResize")
        imageView.contentMode = .center
        
        return imageView
    }()
    
    private let emptyLabel = {
       let label = UILabel()
        
        label.text = "쿠폰을 등록해주세요!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(style: .bmJua, size: 30)
        
        return label
    }()
    
    private let emptyVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 20
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
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .searchLabel
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - button.frame.width * 0.55, bottom: 0, right: 0)
        button.layer.cornerRadius = 6
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let expireCollectionViewHeaderLabel = {
        let label = UILabel()
        
        label.text = "😟 기간이 얼마 안남았어요!"
        label.font = UIFont(style: FontStyle.bold, size: 18)
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
        label.font = UIFont(style: FontStyle.bold, size: 18)
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
        setupViews()
        setupButton()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionViewData()
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
    }
    
    private func updateCollectionViewData() {
        viewModel.fetchCoreData()
        viewModel.sortOutInGlobalThread {
            self.setupCollectionViewIsHiddenAndHeightConstraint()
        }
    }
    
    
    private func setupButton() {
        let searchButtonAction = UIAction { _ in
            let searchViewController = SearchViewController()
            self.navigationController?.pushViewController(searchViewController, animated: true)
        }
        searchButton.addAction(searchButtonAction, for: .touchUpInside)
    }
    
    private func setupViews() {
        
        [emptyImageView, emptyLabel].forEach(emptyVerticalStackView.addArrangedSubview(_:))
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
            contentView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor, multiplier: 1.2),
            
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
            
            recentCollectionViewHeaderLabel.topAnchor.constraint(equalTo: expireCollectionView.bottomAnchor, constant: 25),
            recentCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: expireCollectionViewHeaderLabel.leadingAnchor),
            
            recentCollectionView.topAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.bottomAnchor, constant: 15),
            recentCollectionView.leadingAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.leadingAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: recentCollectionViewHeaderLabel.trailingAnchor),
            recentCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func setupCollectionViewIsHiddenAndHeightConstraint() {
        if viewModel.allGifts.isEmpty {
            emptyVerticalStackView.isHidden = false
            expireCollectionViewHeaderLabel.isHidden = true
            recentCollectionViewHeaderLabel.isHidden = true
            recentCollectionView.heightAnchor.constraint(equalToConstant: .zero).isActive = true
            expireCollectionView.heightAnchor.constraint(equalToConstant: .zero).isActive = true
        }
        
        let expireGifts = viewModel.expireGifts.value
        let recentGifts = viewModel.recentGifts.value
        
        if expireGifts.isEmpty && !recentGifts.isEmpty {
            emptyVerticalStackView.isHidden = true
            expireCollectionViewHeaderLabel.isHidden = true
            expireCollectionView.heightAnchor.constraint(equalToConstant: .zero).isActive = true
            recentCollectionViewHeaderLabel.isHidden = false
            recentCollectionView.heightAnchor.constraint(equalTo: recentCollectionView.widthAnchor, multiplier: 0.85).isActive = true
        } else if !expireGifts.isEmpty && recentGifts.isEmpty {
            emptyVerticalStackView.isHidden = true
            recentCollectionViewHeaderLabel.isHidden = true
            recentCollectionView.heightAnchor.constraint(equalToConstant: .zero).isActive = true
            expireCollectionViewHeaderLabel.isHidden = false
            expireCollectionView.heightAnchor.constraint(equalTo: expireCollectionView.widthAnchor, multiplier: 0.85).isActive = true
        } else if !expireGifts.isEmpty && !recentGifts.isEmpty {
            emptyVerticalStackView.isHidden = true
            expireCollectionViewHeaderLabel.isHidden = false
            expireCollectionView.heightAnchor.constraint(equalTo: expireCollectionView.widthAnchor, multiplier: 0.85).isActive = true
            recentCollectionViewHeaderLabel.isHidden = false
            recentCollectionView.heightAnchor.constraint(equalTo: expireCollectionView.widthAnchor, multiplier: 0.85).isActive = true
        }
    }
}

// MARK: CollectionView Datasource & Delegate 관련
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
            let subtractionResult = viewModel.subtractionOfDays(expireDate: expireGift.expireDate)

            cell.delegate = self
            cell.configureCell(data: expireGift)
            cell.configureTagLabel(subtractionResult)
            return cell
            
        case recentCollectionView:
            let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? MainCollectionViewCell ?? MainCollectionViewCell()
            let recentGift = viewModel.recentGifts.value[indexPath.row]
            
            cell.delegate = self
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

// MARK: UICollectionViewDelegateFlowLayout 관련
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: DetailView Dismiss 이후, Update 처리에 대한 Delegate 관련
extension MainViewController: GiftDidDismissDelegate {
    func didDismissDetailViewController() {
        updateCollectionViewData()
    }
}

extension MainViewController: CollectionViewCellLongPressDelegate {
    func longPressed(_ sender: UILongPressGestureRecognizer) {
        guard let gift = dd(sender) else { return }
        
        let deleteSheetViewModel = DeleteSheetViewModel(gift: gift)
        let deleteSheetViewControlelr = DeleteSheetViewController(viewModel: deleteSheetViewModel)
        deleteSheetViewControlelr.modalPresentationStyle = .overFullScreen
        deleteSheetViewControlelr.modalTransitionStyle = .crossDissolve
        present(deleteSheetViewControlelr, animated: true)
    }
    
    private func dd(_ sender: UILongPressGestureRecognizer) -> Gift? {
        guard let collectionView = sender.view?.superview as? UICollectionView,
              let viewPoint = sender.view?.convert(CGPoint.zero, to: collectionView),
              let indexPath = collectionView.indexPathForItem(at: viewPoint) else { return nil }
        
        switch collectionView {
        case expireCollectionView:
            return viewModel.expireGifts.value[indexPath.row]
        case recentCollectionView:
            return viewModel.recentGifts.value[indexPath.row]
        default:
            break
        }
        return nil
    }

}
