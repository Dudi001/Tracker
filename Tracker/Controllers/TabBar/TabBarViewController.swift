//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.06.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private var trackersViewController: TrackerViewController?
    private lazy var analyticsService = AnalyticsService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .ypBlue
        setupVCs()

    }
    
    private func createNavControllers(for rootViewController: UIViewController,
                                      title: String,
                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        
        if rootViewController is TrackerViewController {
            let button = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(leftButtonTapped))
            button.tintColor = .ypBlack
            rootViewController.navigationItem.leftBarButtonItem = button
            
            let datePicker = UIDatePicker()
            datePicker.overrideUserInterfaceStyle = .light
            datePicker.backgroundColor = .ypLightGray
            datePicker.layer.cornerRadius = 8
            datePicker.layer.masksToBounds = true
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            rootViewController.navigationItem.rightBarButtonItem = datePickerItem
            self.trackersViewController?.datePicker = datePicker
        }
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func setupVCs() {
        let trackersViewController = TrackerViewController()
        let statsViewController = StatisticViewController()
        self.trackersViewController = trackersViewController
        viewControllers = [
            createNavControllers(for: trackersViewController, title: NSLocalizedString("tabBar.trackers.title", comment: ""), image: UIImage(systemName: "record.circle.fill")!),
            createNavControllers(for: statsViewController, title: NSLocalizedString("tabBar.stats.title", comment: ""), image: UIImage(systemName: "hare.fill")!)
        ]
    }
    
    
    @objc
    private func leftButtonTapped() {
        analyticsService.report(event: .click, screen: .main, item: .addTrack)
        trackersViewController?.presentSelectTypeVC()
    }
}
