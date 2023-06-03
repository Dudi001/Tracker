//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.06.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    lazy var emptyImage: UIImageView = {
        let newImage = UIImageView()
        newImage.image = Resourses.Images.trackerEmptyImage
        return newImage
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTracker()
    }
    
    
    private func addTracker() {
        if let navBar = navigationController?.navigationBar {
            let addButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addTrackerButton)
            )
            addButton.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(addButton, animated: false)
        }
    }
    
    
    @objc
    private func addTrackerButton() {
        print("OK")
    }
}
