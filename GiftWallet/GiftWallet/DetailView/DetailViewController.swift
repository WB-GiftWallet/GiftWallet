//
//  DetailViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/21.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    private var viewTranslation = CGPoint(x: 0, y: 0)
    private var isRequireDismissScene = false
    
    private let pagingCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.register(PagingCollectionViewCell.self,
                                forCellWithReuseIdentifier: PagingCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
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
        setupPanGestureRecognizerAttributes()
        setupCollectionViewAttributes()
        setupNavigation()
        setupViews()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollBySelectedIndex()
    }
    
    private func scrollBySelectedIndex() {
        pagingCollectionView.layoutIfNeeded()
        guard let scrollTargetIndex = viewModel.indexPathItem else { return }
        let indexPath = IndexPath(item: scrollTargetIndex, section: 0)
        pagingCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    private func setupCollectionViewAttributes() {
        pagingCollectionView.dataSource = self
        pagingCollectionView.delegate = self
        pagingCollectionView.isPagingEnabled = true
    }
        
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissViewControlelr))
    }
    
    @objc
    private func dismissViewControlelr() {
        dismiss(animated: true)
    }
    
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
}

//MARK: UIColelctionViewDataSource 관련
extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pagingCollectionView.dequeueReusableCell(withReuseIdentifier: PagingCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? PagingCollectionViewCell ?? PagingCollectionViewCell()
        let gift = viewModel.gifts[indexPath.row]
        cell.tapElementDelegate = self
        cell.scrollViewDidTopDelegate = self
        cell.configureCell(data: gift)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
}

// MARK: UICollectionViewDelegateFlowLayout 관련
extension DetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// MARK: UIGestureRecognizer 및 CellScrollToTopDelegate 델리게이트 메소드 관련
extension DetailViewController: UIGestureRecognizerDelegate, CellScrollToTopDelegate {
    func scrollViewDidTop() {
        isRequireDismissScene = true
    }
    
    private func setupPanGestureRecognizerAttributes() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        if isRequireDismissScene {
            switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                if viewTranslation.y > 0 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    })
                    break
                }
                isRequireDismissScene = false
            case .ended:
                if viewTranslation.y < 200 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
                break
            default:
                break
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 다른 Gesture Recognizer와 함께 사용할 수 있도록 true 반환
        return true
    }
}

//MARK: CellElementTappedDelegate 관련
extension DetailViewController: CellElementTappedDelegate {
    func tappedModifyButton(indexPathRow: Int) {
        let gift = viewModel.gifts[indexPathRow]
        let formSheetViewModel = UpdateViewModel(gift: gift)
        let formSheetViewController = FormSheetViewController(viewModel: formSheetViewModel)
        formSheetViewController.delegate = self
        sceneConversion(viewController: formSheetViewController)
    }
    
    func tappedbarcodeButton(indexPathRow: Int) {
        let gift = viewModel.gifts[indexPathRow]
        let barcodeViewModel = BarcodeViewModel(gift: gift)
        let barcodeViewController = BarcodeViewController(viewModel: barcodeViewModel)
        let navigationBarcodeViewController = UINavigationController(rootViewController: barcodeViewController)
        sceneConversion(viewController: navigationBarcodeViewController)
    }
    
    func tappedImageView(indexPathRow: Int) {
        let gift = viewModel.gifts[indexPathRow]
        let zoomViewModel = ZoomImageViewModel(gift: gift)
        let zoomImageViewController = ZoomImageViewController(viewModel: zoomViewModel)
        sceneConversion(viewController: zoomImageViewController)
    }
    
    func tappedUseGiftButton(indexPathRow: Int, text: String?) {
        showAlert(indexPathRow, text)
    }
    
    private func showAlert(_ indexPathRow: Int, _ text: String?) {
        let alertController = UIAlertController(title: "사용 완료 처리할까요?",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "아니요", style: .destructive)
        let okAction = UIAlertAction(title: "네", style: .default) { _ in
            self.doneAction(indexPathRow, text)
        }
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
    
    private func doneAction(_ indexPathRow: Int, _ text: String?) {
        viewModel.writeMemo(indexPathRow, text)
        viewModel.toggleToUnUsableState(indexPathRow)
        viewModel.coreDataUpdate(indexPathRow)
        self.dismiss(animated: true)
    }
    
    private func sceneConversion(viewController: UIViewController) {
        let conversionTargetViewController = viewController
        conversionTargetViewController.modalTransitionStyle = .crossDissolve
        conversionTargetViewController.modalPresentationStyle = .overFullScreen
        present(conversionTargetViewController, animated: true)
    }
}

// MARK: Update 후, 업데이트 관련
extension DetailViewController: GiftDidUpdateDelegate {
    func tapModifyInfo(gift: Gift) {
        guard let index = self.viewModel.findIndexForGiftWithNumber(gift.number) else { return }
        let updateViewModel = UpdateViewModel(gift: viewModel.gifts[index])
        let updateGiftInfoViewController = UpdateGiftInfoViewController(viewModel: updateViewModel)
        let navigationUpdateGiftInfoViewController = UINavigationController(rootViewController: updateGiftInfoViewController)
        sceneConversion(viewController: navigationUpdateGiftInfoViewController)
    }
    
    func didUpdateImage(updatedGift: Gift) {
        viewModel.updateGifts(updatedGift)
        pagingCollectionView.reloadData()
    }
}

