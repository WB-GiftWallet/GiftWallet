//
//  ZoomImageViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/13.
//

import UIKit

class ZoomImageViewController: UIViewController {
    
    private let viewModel: ZoomImageViewModel
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
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
    
    init(viewModel: ZoomImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewAttributes()
        setupPanGestureRecognizerAttributes()
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

// MARK: UIScrollViewDelegate
extension ZoomImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.giftImageView
    }
}

// MARK: UIGestureRecognizerDelegate 관련: drag to dismiss
extension ZoomImageViewController: UIGestureRecognizerDelegate {
    private func setupPanGestureRecognizerAttributes() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            if viewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
                break
            }
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                modalTransitionStyle = .coverVertical
                dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
}
