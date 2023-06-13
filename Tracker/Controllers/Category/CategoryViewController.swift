//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit


final class CategoryViewController: UIViewController {
    var trackerViewController: TrackerViewProtocol?

    var selectedIndexPath: IndexPath?
    var createTrackerViewController: CreateTrackerViewControllerProtocol?
    
    
    lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.text = "Категория"
        item.textColor = .ypBlack
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return item
    }()
    
    lazy var emptyImage: UIImageView = {
        let newImage = UIImageView()
        newImage.translatesAutoresizingMaskIntoConstraints = false
        newImage.image = Resourses.Images.trackerEmptyImage
        return newImage
    }()
    
    lazy var emptyLabel: UILabel = {
       let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.text = "Привычки и события можно\nобъединить по смыслу"
        newLabel.tintColor = .ypBlack
        newLabel.numberOfLines = 0
        newLabel.textAlignment = .center
        newLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return newLabel
    }()
    
    lazy var categoryTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .singleLine
        element.layer.cornerRadius = 16
        element.isScrollEnabled = false
        element.backgroundColor = .ypBlack
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var categoryButton: UIButton = {
        let item = UIButton(type: .system)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.setTitle("Добавить категорию", for: .normal)
        item.backgroundColor = .ypBlack
        item.tintColor = .ypWhite
        item.layer.cornerRadius = 16
        item.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        item.titleLabel?.textAlignment = .center
        item.addTarget(self, action: #selector(switchToNewCategoryViewController), for: .touchUpInside)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        checkCellsCount()
        addConstraints()
        setupTableView()
        emptyImage.removeFromSuperview()
        emptyLabel.removeFromSuperview()
        view.addSubview(categoryTableView)
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func checkCellsCount() {
        if trackerViewController?.categories.count == 0 {
            view.addSubview(emptyImage)
            view.addSubview(emptyLabel)
            categoryTableView.removeFromSuperview()

            NSLayoutConstraint.activate([
                emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8)
            ])
        } else {
            emptyImage.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            view.addSubview(categoryTableView)
            
            NSLayoutConstraint.activate([
                categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                categoryTableView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }
    }
    
    private func addViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view.addSubview(categoryButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryButton.heightAnchor.constraint(equalToConstant: 60),
            categoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func switchToNewCategoryViewController() {
        let newCategoryVC = NewCategoryViewController()
        present(newCategoryVC, animated: true)
    }
    
    
    private func setupTableView() {
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    
}


//MARK: UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  trackerViewController?.categories.count ?? 0
//        if categoryArray.isEmpty {
//            return 1
//        } else {
//            return categoryArray.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        
        cell.configureCell(text: trackerViewController?.categories[indexPath.row].name ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

//MARK: UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedIndexPath = selectedIndexPath {
            if let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? CategoryTableViewCell {
                selectedCell.accessoryType = .none

                if selectedIndexPath == indexPath {
                    self.selectedIndexPath = nil
                    return
                }
            }
        }

        if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath

            createTrackerViewController?.selectedCategory = cell.label.text
            createTrackerViewController?.reloadTableView()
            dismiss(animated: true)
        }
    }
}
