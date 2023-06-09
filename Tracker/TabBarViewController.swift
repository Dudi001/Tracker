//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.06.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    private func configure() {

        
        tabBar.tintColor = .ypBlue
        tabBar.barTintColor = .ypGray
        tabBar.backgroundColor = .ypBackground
        tabBar.layer.borderColor = CGColor(gray: 1, alpha: 1)

        
        
//        let trackerViewPresenter = TrackerViewPresenter()
        let trackerViewController = TrackerViewController()
//        trackerViewController.presenter = trackerViewPresenter
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        let statisticNavigationController = UINavigationController(rootViewController: StatisticViewController())
        
        trackerNavigationController.navigationBar.prefersLargeTitles = true
        trackerNavigationController.navigationItem.largeTitleDisplayMode = .automatic
        trackerNavigationController.navigationBar.topItem?.title = "Трекеры"
        
        statisticNavigationController.navigationBar.prefersLargeTitles = true
        statisticNavigationController.navigationItem.largeTitleDisplayMode = .automatic
        statisticNavigationController.navigationBar.topItem?.title = "Статистика"
        
        trackerNavigationController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                        image: UIImage(systemName: "record.circle.fill"),
                                                        selectedImage: nil)
        statisticNavigationController.tabBarItem = UITabBarItem(title: "Статистика",
                                                          image: UIImage(systemName: "hare.fill"),
                                                          selectedImage: nil)
        
        self.viewControllers = [trackerNavigationController, statisticNavigationController]
        
    }
}
