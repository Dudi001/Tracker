//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Мурад Манапов on 08.06.2023.
//

import UIKit


final class SupplementaryView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = .boldSystemFont(ofSize: 19)
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraintsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    private func setupConstraintsView() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
