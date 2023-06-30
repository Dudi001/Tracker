//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 03.06.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    private lazy var emptyLabel: UILabel = {
        let empty = UILabel()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.text = "Анализировать пока нечего"
        empty.textColor = .ypBlack
        empty.textAlignment = .center
        empty.font = .systemFont(ofSize: 12, weight: .medium)
        return empty
    }()
    
    private lazy var emptyImage: UIImageView = {
        let item = UIImageView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.image = Resourses.Images.statisticEmptyImage
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(emptyImage)
        view.addSubview(emptyLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8)
        ])
    }
}
