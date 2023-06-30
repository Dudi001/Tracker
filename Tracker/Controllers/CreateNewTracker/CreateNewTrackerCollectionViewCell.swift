//
//  Crea.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit


final class CreateNewTrackerCollectionViewCell: UICollectionViewCell {
    lazy var emojiLabel: UILabel = {
       let emoji = UILabel()
        emoji.font = UIFont.systemFont(ofSize: 32)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        return emoji
    }()
    
    lazy var colorImage: UIImageView = {
       let colorItem = UIImageView()
        colorItem.translatesAutoresizingMaskIntoConstraints = false
        colorItem.layer.cornerRadius = 8
        return colorItem
    }()
    
    
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                backgroundColor = .none
                layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmojiCell(emoji: String) {
        emojiLabel.text = emoji
    }
    
    func configureColorCell(color: UIColor) {
        colorImage.backgroundColor = color
    }
    
    private func setupViews() {
        addSubview(emojiLabel)
        addSubview(colorImage)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            colorImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            colorImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            colorImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            colorImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
}


