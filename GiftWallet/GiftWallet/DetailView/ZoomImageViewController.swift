//
//  ZoomImageViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/13.
//

import UIKit

class ZoomImageViewController: UIViewController {

    private let viewModel: ZoomingImageViewModel
    
    private let scrollView = {
       let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let giftImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(viewModel: ZoomingImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewAttributes()
        configureImageView()
        setupViews()
    }
    
    private func configureImageView() {
        giftImageView.image = viewModel.gift.image
    }

    private func scrollViewAttributes() {
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        scrollView.addSubview(giftImageView)
        view.addSubview(scrollView)
        
        let contentLayoutGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            giftImageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            giftImageView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            giftImageView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            giftImageView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            giftImageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            giftImageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}

extension ZoomImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.giftImageView
    }
}
