//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 12.06.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    var categoryViewController: CategoryViewControllerProtocol?
    private let dataProvider = DataProvider.shared
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Новая категория"
        label.textColor = .ypBlack
       return label
    }()
    
    lazy var textField: UITextField = {
       let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clearButtonMode = .whileEditing
        text.returnKeyType = .go
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.leftViewMode = .always
        text.layer.cornerRadius = 16
        text.backgroundColor = .ypBackground
        text.placeholder = "Введите название категории"
        return text
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createNewCategory), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        setViews()
        setConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func createNewCategory() {
        guard let name = textField.text else { return }
        dataProvider.addCategory(header: name)
        dataProvider.updateCategories()
        dismiss(animated: true)

        categoryViewController?.reloadTableView()
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        completeButton.backgroundColor = textField.text?.count != 0 ? .ypBlack : .gray
    }
}

// MARK: Setting views:
extension NewCategoryViewController {
    private func setViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(completeButton)
    }
}

// MARK: Setting constraints:
extension NewCategoryViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}
