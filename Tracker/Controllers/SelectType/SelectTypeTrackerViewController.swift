//
//  SelectTypeTrackerViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 10.06.2023.
//

import UIKit


final class SelectTypeTrackerViewController: UIViewController {
    lazy var titileLabel: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Создание трекера"
        text.font = UIFont.systemFont(ofSize: 16)
        return text
    }()
    
    lazy var hobbyButton: UIButton = {
        let hobby = UIButton()
        hobby.translatesAutoresizingMaskIntoConstraints = false
        hobby.setTitle("Привычка", for: .normal)
        hobby.backgroundColor = .ypWhite
        hobby.layer.cornerRadius = 16
        hobby.addTarget(self, action: #selector(hobbyButtonTappet), for: .touchUpInside)
        return hobby
    }()
    
    lazy var irregularButton: UIButton = {
        let irregular = UIButton()
        irregular.translatesAutoresizingMaskIntoConstraints = false
        irregular.setTitle("Нерегуляное событие", for: .normal)
        irregular.backgroundColor = .ypWhite
        irregular.layer.cornerRadius = 16
        return irregular
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addViews()
        configureTitele()
        configureHobbyButton()
        configureIrregularButton()
    }
    
    @objc
    private func hobbyButtonTappet() {
        let newTrackerVC = CreateNewTrackerViewController()
        present(newTrackerVC, animated: true)
    }
    
    @objc
    private func irregularButtonTappet() {
        let newTrackerVC = CreateNewTrackerViewController()
        present(newTrackerVC, animated: true)
    }
    
    
    private func addViews() {
        view.addSubview(titileLabel)
        view.addSubview(hobbyButton)
        view.addSubview(irregularButton)
    }
    
    private func configureTitele() {
        NSLayoutConstraint.activate([
            titileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureHobbyButton() {
        NSLayoutConstraint.activate([
            hobbyButton.heightAnchor.constraint(equalToConstant: 60),
            hobbyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hobbyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hobbyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureIrregularButton() {
        NSLayoutConstraint.activate([
            irregularButton.heightAnchor.constraint(equalToConstant: 60),
            irregularButton.topAnchor.constraint(equalTo: hobbyButton.bottomAnchor, constant: 16),
            irregularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    
}
