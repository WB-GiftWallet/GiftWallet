//
//  DetailViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

final class DetailViewController: UIViewController {
        
    private let viewModel: DetailViewModel
    
    private let pagingCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.register(PagingCollectionViewCell.self,
                                forCellWithReuseIdentifier: PagingCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureImageTapGesture()
        setupCollectionViewAttributes()
        setupNavigation()
        setupViews()
//        configureGiftData()
    }
    
//    private func configureGiftData() {
//        brandLabel.text = viewModel.brandName
//        productNameLabel.text = viewModel.productName
//        dateDueLabel.text = viewModel.expirdDate
//        memoTextField.text = viewModel.memo
//        giftImageView.image = viewModel.gift.image
//    }
    
    private func setupCollectionViewAttributes() {
        pagingCollectionView.dataSource = self
        pagingCollectionView.delegate = self
        pagingCollectionView.isPagingEnabled = true

    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .black
    }
    
//    private func configureImageTapGesture() {
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
//
//        giftImageView.isUserInteractionEnabled = true
//        giftImageView.addGestureRecognizer(gestureRecognizer)
//    }
    
    @objc private func tapSeletedButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "사용 완료 처리할까요?"
        
        let cancel = UIAlertAction(title: "아니요", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        let done = UIAlertAction(title: "네", style: .default) { _ in
//            self.doneAction()
        }

        [cancel, done].forEach(alert.addAction(_:))
        present(alert, animated: true)
    }
    
//    private func doneAction() {
//        changeGiftState()
//        viewModel.writeMemo(memoTextField.text)
//        viewModel.coreDataUpdate()
//    }
    
//    private func changeGiftState() {
//        viewModel.toggleToUnUsableState()
//        selectedButton.backgroundColor = .systemGray
//        dismiss(animated: true)
//    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(pagingCollectionView)
        
        NSLayoutConstraint.activate([
            pagingCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            pagingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    @objc private func tapImageView(sender: UITapGestureRecognizer) {
        let gift = viewModel.gift
        
        let viewModel = GiftImageViewModel(gift: gift)
        let giftImageViewController = GiftImageViewController(viewModel: viewModel)
        giftImageViewController.modalPresentationStyle = .fullScreen
        present(giftImageViewController, animated: true)
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pagingCollectionView.dequeueReusableCell(withReuseIdentifier: PagingCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? PagingCollectionViewCell ?? PagingCollectionViewCell()
        cell.sampleConfigure()
        
        return cell
    }
    

}

extension DetailViewController: UICollectionViewDelegate {
}


extension DetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
