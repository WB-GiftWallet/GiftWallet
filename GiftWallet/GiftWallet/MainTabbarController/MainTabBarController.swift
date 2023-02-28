//
//  MainTabBarController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/23.
//

import UIKit

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
    private lazy var addGiftViewController: UIViewController = {
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
        
        configureEachViewControllers()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            isAddGiftTabBarEnabled = false
            
            //TODO: AddViewController 구현 및 present
            let temporaryVC = UIViewController()
            temporaryVC.view.backgroundColor = .systemPurple
            let gift = Gift(image: UIImage(systemName: "cloud"), category: .bread, brandName: "안녕", productName: "응", memo: "유ㅣㅇ", expireDate: Date())
            try? CoreDataManager.shared.saveData(gift)
            present(temporaryVC, animated: true)
        } else {
            isAddGiftTabBarEnabled = true
        }
    }
    
    private func configureEachViewControllers() {
        // TODO: Color 변경
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemPink
        
        viewControllers = [mainViewController, addGiftViewController, settingViewController]
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
