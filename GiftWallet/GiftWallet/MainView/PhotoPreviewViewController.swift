//
//  PhotoPreviewViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/23.
//

import UIKit

class PhotoPreviewViewController: UIViewController {
    
    private let image: UIImage
    
    private lazy var imageView = {
        let imageView = UIImageView()
        
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.frame = view.bounds
        
        return imageView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
    }
    
}
