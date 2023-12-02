//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 03.06.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let statsViewModel = StatsViewModel()
    
    private lazy var placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = Resourses.Images.statisticEmptyImage
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ypBlack
        label.text = NSLocalizedString("stats.placeHolder.title", comment: "placeholder title")
        return label
    }()
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(StatsCell.self, forCellReuseIdentifier: "StatsCell")
        table.layer.cornerRadius = 10
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        view.addSubview(placeholder)
        view.addSubview(label)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    
}
    extension StatisticViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            90
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
            let count = statsViewModel.getCompletedTrackers()
            cell.countLabel.text = "\(count)"
            cell.headerLabel.text = "Трекеров завершено"
            cell.selectionStyle = .none
            cell.setupGradient()
            return cell
        }
}

extension StatisticViewController: UITableViewDelegate {
    
}
