//
//  CreateNewTrackerTableVIewCell.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit


final class CreateNewTrackerTableVIewCell: UITableViewCell {
    lazy var label: UILabel = {
        let labelItem = UILabel()
        labelItem.font = .systemFont(ofSize: 17, weight: .regular)
        labelItem.textColor = .ypBlack
        return labelItem
    }()
    
    private lazy var categoryLabel: UILabel = {
        let item = UILabel()
        item.font = .systemFont(ofSize: 17, weight: .regular)
        item.textColor = .ypGray
        return item
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .ypBackground
        accessoryType = .disclosureIndicator
    }
    
    
    func configureCellWithoutCategory() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        ])
        
    }
    
    func configureCellWithCategory(_ with: String) {
        addSubview(label)
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2)
        ])
        
        
        categoryLabel.text = with
    }
}
