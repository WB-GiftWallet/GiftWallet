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
                return "house"
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
        viewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
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
        viewController.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        
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
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        
        viewControllers = [mainViewController, blankViewController, settingViewController]
    }
    
    private func setupNavigation() {
        // TODO: SampleLogo 수정필요
        title = ""
        
        let image = UIImage(named: "SampleLogoWow")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 50)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)
        

        
        let bellAction = UIAction { _ in
            let alarmListViewModel = AlarmListViewModel()
            let alarmListViewController = AlarmListViewController(viewModel: alarmListViewModel)
            self.navigationController?.pushViewController(alarmListViewController, animated: true)
        }
        
        let bellSFSymbol = UIImage(systemName: "bell.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: bellSFSymbol,
                                                            primaryAction: bellAction)
        navigationItem.rightBarButtonItem?.tintColor = .black
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
                guard let formattedImage = self.getImage(results: results) else { return }
                let addViewModel = AddViewModel(seletedImage: formattedImage)
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
    
    private func getImage(results: [PHPickerResult]) -> UIImage? {
        var formattedImage: UIImage?
        guard let itemProvider = results.first?.itemProvider else { return nil }

        let semaphore = DispatchSemaphore(value: 0)
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    formattedImage = image as? UIImage
                }
                semaphore.signal()
            })
        }
        semaphore.wait()
        
        return formattedImage
    }
    
}
