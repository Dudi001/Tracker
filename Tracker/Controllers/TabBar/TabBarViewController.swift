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
        tabBar.barTintColor = .ypWhite
        tabBar.backgroundColor = .ypWhite
        tabBar.layer.borderColor = CGColor(gray: 1, alpha: 1)

        let trackerViewController = TrackerViewController()
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        let statisticNavigationController = UINavigationController(rootViewController: StatisticViewController())
        
        trackerNavigationController.navigationBar.prefersLargeTitles = true
        trackerNavigationController.navigationItem.largeTitleDisplayMode = .automatic
        trackerNavigationController.navigationBar.topItem?.title = NSLocalizedString("tabBar.trackers.title", comment: "")
        
        statisticNavigationController.navigationBar.prefersLargeTitles = true
        statisticNavigationController.navigationItem.largeTitleDisplayMode = .automatic
        statisticNavigationController.navigationBar.topItem?.title = NSLocalizedString("tabBar.stats.title", comment: "")
        
        trackerNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("tabBar.trackers.title", comment: ""),
                                                        image: UIImage(systemName: "record.circle.fill"),
                                                        selectedImage: nil)
        statisticNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("tabBar.stats.title", comment: ""),
                                                          image: UIImage(systemName: "hare.fill"),
                                                          selectedImage: nil)
        
        self.viewControllers = [trackerNavigationController, statisticNavigationController]
        
    }
}
