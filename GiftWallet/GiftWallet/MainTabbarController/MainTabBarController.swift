//
//  MainTabBarController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/23.
//

import UIKit
import PhotosUI

final class MainTabBarController: UITabBarController {
    
    private let mainViewModel: MainViewModel
    private let etcSettingViewModel: EtcSettingViewModel
    
    private enum tag: Int {
        case detail
        case addGift
        case setting
        
        var systemName: String {
            switch self {
            case .detail:
                return "list.clipboard.fill"
            case .addGift:
                return "plus.circle.fill"
            case .setting:
                return "gearshape"
            }
        }
    }
    
    private lazy var mainViewController: UIViewController = {
        let viewController = MainViewController(viewModel: mainViewModel)
        
        viewController.tabBarItem.image = UIImage(systemName: tag.detail.systemName)
        viewController.tabBarItem.tag = tag.detail.rawValue
        
        return viewController
    }()
    
    // TODO: AddGiftViewController 구현 및 연결
    private lazy var blankViewController: UIViewController = {
        let viewController = UIViewController()
        
        viewController.tabBarItem.image = UIImage(
            systemName: tag.addGift.systemName,
            withConfiguration: UIImage.SymbolConfiguration(
                font: .systemFont(ofSize: 45)
            )
        )?.withBaselineOffset(fromBottom: UIFont.systemFontSize * 2)
        viewController.tabBarItem.tag = tag.addGift.rawValue
        
        return viewController
    }()
    
    // TODO: settingViewController 구현 및 연결
    private lazy var settingViewController: UIViewController = {
        let viewController = EtcSettingViewController(viewModel: etcSettingViewModel)
        
        viewController.tabBarItem.image = UIImage(systemName: tag.setting.systemName)
        viewController.tabBarItem.tag = tag.setting.rawValue
        
        return viewController
    }()
    
    private var isAddGiftTabBarEnabled = true
    
    init(mainViewModel: MainViewModel, etcSettingViewModel: EtcSettingViewModel) {
        self.mainViewModel = mainViewModel
        self.etcSettingViewModel = etcSettingViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        setupNavigation()
        configureEachViewControllers()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            isAddGiftTabBarEnabled = false
            presentPHPicekrViewController()
        } else {
            isAddGiftTabBarEnabled = true
        }
    }
    
    private func configureEachViewControllers() {
        // TODO: Color 변경
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemPink
        
        viewControllers = [mainViewController, blankViewController, settingViewController]
    }
    
    private func setupNavigation() {
        title = ""
        
        let searchAction = UIAction { _ in
            print("검색창 전환")
        }
        let bellAction = UIAction { _ in
            //TODO: 알림 리스트 전환으로 변경
            print("CoreData 추가")
            Gift.addSampleData()
        }
        
        let searchSFSymbol = UIImage(systemName: "magnifyingglass")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: searchSFSymbol,
                                                           primaryAction: searchAction)
        let bellSFSymbol = UIImage(systemName: "bell.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: bellSFSymbol,
                                                            primaryAction: bellAction)
        navigationController?.navigationBar.tintColor = .black
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        return isAddGiftTabBarEnabled
    }
}

extension MainTabBarController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty {
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true) {
                print(results)
                let addViewModel = AddViewModel()
                let addViewControlller = AddViewController(viewModel: addViewModel, page: .brand)
                let navigationAddViewController = UINavigationController(rootViewController: addViewControlller)
                navigationAddViewController.modalPresentationStyle = .fullScreen
                self.present(navigationAddViewController, animated: true)
            }
        }
    }
    
    private func presentPHPicekrViewController() {
        let configuration = setupPHPicekrConfiguration()
        let picekrViewController = PHPickerViewController(configuration: configuration)
        
        picekrViewController.delegate = self
        picekrViewController.modalPresentationStyle = .fullScreen
        
        present(picekrViewController, animated: true)
    }
    
    private func setupPHPicekrConfiguration() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selectionLimit = 1
        
        return configuration
    }
}
