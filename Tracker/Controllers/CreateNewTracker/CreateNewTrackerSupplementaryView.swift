//
//  CreateNewTrackerSupplementaryView.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit


final class CreateNewTrackerSupplementaryView: UICollectionReusableView {
    lazy var headerLabel: UILabel = {
        let header = UILabel()
        header.textColor = .ypBlack
        header.font = UIFont.systemFont(ofSize: 19)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVIews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVIews() {
        addSubview(headerLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}
