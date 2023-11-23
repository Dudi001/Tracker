//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Мурад Манапов on 12.06.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    lazy var label: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.font = .systemFont(ofSize: 17, weight: .regular)
        element.textColor = .ypBlack
        return element
    }()
    
//    var configureCell: String? {
//        didSet {
//            label.text = configureCell
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .ypBackground
        setupView()
        addConstraints()
    }
    
    func configureCell(text: String) {
        label.text = text
    }
    
    private func setupView() {
        addSubview(label)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 285)
        ])
    }
}

