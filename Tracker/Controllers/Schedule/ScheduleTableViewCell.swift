//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Мурад Манапов on 14.06.2023.
//

import UIKit


protocol ScheduleViewControllerDelegate: Any {
    func addDaysToSchedule(cell: ScheduleTableViewCell)
}


final class ScheduleTableViewCell: UITableViewCell {
    
    var delegate: ScheduleViewControllerDelegate?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self, action: #selector(addSchedule), for: .allTouchEvents)
        return switcher
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        addConstraints()
        backgroundColor = .ypBackground
    }
    
    func configureCell(text: String) {
        label.text = text
    }
    
    @objc private func addSchedule() {
        delegate?.addDaysToSchedule(cell: self)
    }
    
    private func setupView() {
        addSubview(label)
        addSubview(switcher)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

