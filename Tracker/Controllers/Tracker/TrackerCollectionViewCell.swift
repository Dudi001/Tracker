//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Мурад Манапов on 03.06.2023.
//

import UIKit


final class TrackerCollectionViewCell: UICollectionViewCell {
    lazy var cellView: UIView = {
        let cell = UIView()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = .colorSection1
        cell.layer.cornerRadius = 16
        return cell
    }()
    
    lazy var emojiLabel: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.textAlignment = .center
        emoji.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        emoji.layer.cornerRadius = emoji.bounds.height / 2
        emoji.font = UIFont.systemFont(ofSize: 12)
        emoji.backgroundColor = .white.withAlphaComponent(0.3)
        emoji.layer.masksToBounds = true
        return emoji
    }()
    
    lazy var textTrackerLabel: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 12)
        text.textColor = .ypWhite
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        text.numberOfLines = 2
        return text
    }()
    
    lazy var trackerCompleteButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .colorSection1
        let image = UIImage(systemName: "plus")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var counterDayLabel: UILabel = {
        let day = UILabel()
        day.translatesAutoresizingMaskIntoConstraints = false
        day.textAlignment = .left
        day.font = UIFont.systemFont(ofSize: 12)
        day.text = "1 день"
        return day
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewCell()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViewCell() {
        contentView.addSubview(cellView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(textTrackerLabel)
        contentView.addSubview(trackerCompleteButton)
        contentView.addSubview(counterDayLabel)
    }
    
    private func configureCell() {
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.bounds.height * 0.39)),
            
            textTrackerLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            textTrackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textTrackerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            textTrackerLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -12),
            
            trackerCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerCompleteButton.topAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 8),
            trackerCompleteButton.heightAnchor.constraint(equalToConstant: 34),
            trackerCompleteButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterDayLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            counterDayLabel.centerYAnchor.constraint(equalTo: trackerCompleteButton.centerYAnchor)
        ])
    }

}
