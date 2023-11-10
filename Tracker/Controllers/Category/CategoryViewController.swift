//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit

protocol CategoryViewControllerProtocol: AnyObject {
    func reloadTableView()
}

protocol NewTrackerViewModelDelegate: AnyObject {
    func updateCategory()
}


final class CategoryViewController: UIViewController, CategoryViewControllerProtocol {
    private let dataProvider = DataProvider.shared
//    var selectedIndexPath: IndexPath?
    var createTrackerViewController: CreateTrackerViewControllerProtocol?
//    private var categoryArray: [String] = []
    private var viewModel: CategoryViewModel!
    
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
        element.backgroundColor = .ypBackground
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
//        categoryArray = DataProvider.shared. ()
        checkCellsCount()
        addConstraints()
        setupTableView()
        viewModel = CategoryViewModel()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = viewModel.selectedIndexPath {
            categoryTableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
            tableView(categoryTableView, didSelectRowAt: selectedIndexPath)
        }
    }
    
    private func bind() {
        viewModel.$categoryArray.bind {[weak self] _ in
            self?.categoryTableView.reloadData()
        }
    }
    
    func checkCellsCount() {
        if viewModel.categoryArray.isEmpty {
            view.addSubview(emptyImage)
            view.addSubview(emptyLabel)
            categoryTableView.removeFromSuperview()

            NSLayoutConstraint.activate([
                emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 248),
                
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
//                categoryTableView.heightAnchor.constraint(equalToConstant: 250)
                categoryTableView.bottomAnchor.constraint(equalTo: categoryButton.topAnchor, constant: -30)
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
    
    @objc
    private func switchToNewCategoryViewController() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.categoryViewController = self
        present(newCategoryVC, animated: true)
    }
    
    func reloadTableView() {
//        categoryArray = dataProvider.getCategories()
        viewModel.updateData()
        categoryTableView.reloadData()
//        checkToSetupDumb()
        
    }
    

    private func checkToSetupDumb() {
        categoryTableView.alpha = viewModel.categoryArray.isEmpty ? 0 : 1
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
        if viewModel.categoryArray.isEmpty {
            return 1
        } else {
            return viewModel.categoriesCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        cell.configureCell = viewModel.getCategory(at: indexPath.row)
//        cell.configureCell(text: viewModel.categoryArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

//MARK: UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
//
//        if let selectedIndexPath = viewModel.selectedIndexPath {
//            if let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? CategoryTableViewCell {
//                selectedCell.accessoryType = .none
//
//                if selectedIndexPath == indexPath {
//                    viewModel.clearSelection()
//                    return
//                }
//            }
//        }
//
//
//        if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
//            cell.accessoryType = .checkmark
//            viewModel.selectedIndexPath = indexPath
//
//            dataProvider.selectedCategory = cell.label.text
//            createTrackerViewController?.reloadTableView()
//            dismiss(animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.clearSelection()
        tableView.reloadData()
    }
}


extension CategoryViewController: NewTrackerViewModelDelegate {
    func updateCategory() {
        viewModel.updateData()
    }
}
