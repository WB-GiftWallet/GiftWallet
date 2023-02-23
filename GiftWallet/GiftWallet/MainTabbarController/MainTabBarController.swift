//
//  MainTabBarController.swift
//  GiftWallet
//
//  Created by Baem on 2023/02/23.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var isAddGiftTabBarEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // TODO: Color 변경
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemPink
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        let deTailViewController = MainViewController(viewModel: MainViewModel())
        deTailViewController.tabBarItem.image = UIImage(systemName: "list.clipboard.fill")
        deTailViewController.tabBarItem.tag = 0
        
        // TODO: AddGiftViewController구현 및 연결
        let addGiftViewController = UIViewController()
        addGiftViewController.view.backgroundColor = .yellow
        addGiftViewController.tabBarItem.image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 45)))?.withBaselineOffset(fromBottom: UIFont.systemFontSize * 2)
        addGiftViewController.tabBarItem.tag = 1
        
        let settingViewController = UIViewController()
        settingViewController.tabBarItem.image = UIImage(systemName: "gearshape")
        settingViewController.tabBarItem.tag = 2
        
        viewControllers = [deTailViewController, addGiftViewController, settingViewController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let previousIndex = self.selectedIndex
            
            self.selectedIndex = previousIndex
            isAddGiftTabBarEnabled = false
            
            //TODO: AddViewController 구현 및 present
            let temporaryVC = UIViewController()
            temporaryVC.view.backgroundColor = .systemPurple
            present(temporaryVC, animated: true)
            
        } else {
            isAddGiftTabBarEnabled = true
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return isAddGiftTabBarEnabled
    }
}
