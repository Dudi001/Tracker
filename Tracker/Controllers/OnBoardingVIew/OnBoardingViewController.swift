//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 19.10.2023.
//

import UIKit


final class OnboardingViewController: UIViewController {
    var header: String
    private var backgroundImage: UIImage?
    
    init(header: String, backgroundImage: UIImage) {
        self.header = header
        self.backgroundImage = backgroundImage
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundImageView: UIImageView = {
      let backImage = UIImageView()
        backImage.translatesAutoresizingMaskIntoConstraints = false
        backImage.contentMode = .scaleAspectFill
        return backImage
    }()
    
    private lazy var headerLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = header
        textLabel.font = UIFont.boldSystemFont(ofSize: 32)
        textLabel.textColor = .ypBlack
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(headerLabel)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -16)
        ])
    }
}
