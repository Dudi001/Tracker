//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Мурад Манапов on 18.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let tabBar = TabBarViewController()
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        if onboardingViewViewControllerWasShown() == false {
            window.rootViewController = OnboardinMainViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        } else {
            window.rootViewController = tabBar
        }

        self.window = window
        window.makeKeyAndVisible()
    }
    
    func onboardingViewViewControllerWasShown() -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        return isFirstLaunch
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

