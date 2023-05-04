//
//  AppDelegate.swift
//  GiftWallet
//
//  Created by WB on 2023/02/19.
//

import UIKit
import CoreData
import FirebaseCore
import KakaoSDKCommon
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: LaunchScreen Time (500000)
        usleep(500000)
        
        //MARK: IQKeyboard Method
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //MARK: FireBase Method
        FirebaseApp.configure()
        
        //MARK: KakaoSDK Init
        KakaoSDK.initSDK(appKey: "16f9d943fc2e2b512f145c73a1263e39")
        
        //MARK: Notifiaction 권한 승인 로직 및 UserNotification Action Setting
        configureNotification()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "GiftWallet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: 화면방향 설정 관련
    var shouldSupportAllOrientation = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldSupportAllOrientation {
            return [.landscapeRight]
        } else {
            return [.portrait]
        }
    }
}


// MARK: UserNotificationCenter Method
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    private func configureNotification() {
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("error: ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        
        if application.applicationState == .active {
            debugPrint("Push Alarm Tap : ACTIVE")
        }
        
        if application.applicationState == .inactive || application.applicationState == .background {
            debugPrint("Push Alarm Tap : INACTIVE")
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.first  else { return }
            
            let mainViewModel = MainViewModel()
            let etcSettingViewModel = EtcSettingViewModel()
            let mainTabBarController = MainTabBarController(mainViewModel: mainViewModel,
                                                            etcSettingViewModel: etcSettingViewModel)
            let navigationMainController = UINavigationController(rootViewController: mainTabBarController)
            
            window.backgroundColor = .systemBackground
            window.rootViewController = navigationMainController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
            
            let viewModel = AlarmListViewModel()
            let alarmViewController = AlarmListViewController(viewModel: viewModel)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                //MARK: 가장 위 TopViewController GET == MainTabbarController
                let topViewController = UIApplication.getMostTopViewController()
                topViewController?.navigationController?.pushViewController(alarmViewController, animated: true)
            }
        }
    }
}
