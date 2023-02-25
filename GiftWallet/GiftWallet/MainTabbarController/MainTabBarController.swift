//
//  MainTabBarController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/23.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
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
    
    private let mainViewController: MainViewController = {
        let viewController = MainViewController(viewModel: MainViewModel())
        
        viewController.tabBarItem.image = UIImage(systemName: tag.detail.systemName)
        viewController.tabBarItem.tag = tag.detail.rawValue
        
        return viewController
    }()
    
    // TODO: AddGiftViewController 구현 및 연결
    private let addGiftViewController: UIViewController = {
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
    private let settingViewController: UIViewController = {
        let viewController = UIViewController()
        
        viewController.tabBarItem.image = UIImage(systemName: tag.setting.systemName)
        viewController.tabBarItem.tag = tag.setting.rawValue
        
        return viewController
    }()
    
    private var isAddGiftTabBarEnabled = true
    
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
