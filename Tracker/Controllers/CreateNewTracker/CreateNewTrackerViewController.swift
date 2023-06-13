//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit



enum TypeOfTracker {
    case hobby
    case irregular
}

protocol CreateTrackerViewControllerProtocol {
    var selectedCategory: String? { get set }
    var selectedSchedule: String? { get set }
    func reloadTableView()
}

final class CreateNewTrackerViewController: UIViewController {
    var trackerViewController: TrackerViewProtocol?
    var typeOfTracker: TypeOfTracker?
    
    var selectedCategory: String?
    var selectedSchedule: String?
    
    var trackerName: String?
    var trackerEmoji: String?
    var trackerColor: UIColor?
    var schedule: [Int] = []
    
    static let colllectionViewHeightWithSchedule: CGFloat = 618.0
    static let colllectionViewHeight: CGFloat = 543.0
    
    
    var emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    var colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6,
        .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12,
        .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18,
    ]
    
    let tableViewTitle = ["Категория", "Расписание"]
    
    
    lazy var titileHobbyLabel: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        text.textColor = .ypBlack
        return text
    }()
    
    
    lazy var hobbyNameTextField: UITextField = {
       let hobbyText = UITextField()
        hobbyText.placeholder = "Введите название трекера"
        hobbyText.backgroundColor = .ypBackground
        hobbyText.clearButtonMode = .whileEditing
        hobbyText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        hobbyText.leftViewMode = .always
        hobbyText.returnKeyType = .done
        hobbyText.layer.cornerRadius = 16
        hobbyText.font = .systemFont(ofSize: 17, weight: .regular)
        hobbyText.textColor = .ypBlack
        hobbyText.translatesAutoresizingMaskIntoConstraints = false
        return hobbyText
    }()
    
    lazy var warningLabel: UILabel = {
        let element = UILabel()
        element.text = "Ограничение 38 символов"
        element.font = .systemFont(ofSize: 17, weight: .regular)
        element.textColor = .ypRed
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var categoryAndScheduleTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .singleLine
        element.layer.cornerRadius = 16
        element.isScrollEnabled = false
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var collectionView: UICollectionView = {
        let element = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        element.backgroundColor = .ypWhite
        element.isScrollEnabled = false
        element.allowsMultipleSelection = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var cancelButton: UIButton = {
        let element = UIButton(type: .system)
        element.layer.cornerRadius = 16
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.ypRed.cgColor
        element.setTitle("Отменить", for: .normal)
        element.titleLabel?.textAlignment = .center
        element.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        element.backgroundColor = .ypWhite
        element.tintColor = .ypRed
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var createButton: UIButton = {
        let element = UIButton(type: .system)
        element.layer.cornerRadius = 16
        element.setTitle("Создать", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        element.setTitleColor(.white, for: .normal)
        element.backgroundColor = .ypGray
        element.isEnabled = false
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    let bottomButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstant()
        setupTableView()
        setupCollectionView()
        
    }
    
    func reloadTableView() {
        categoryAndScheduleTableView.reloadData()
    }

//MARK: - Register cell
    private func setupTableView() {
            categoryAndScheduleTableView.register(CreateNewTrackerTableVIewCell.self, forCellReuseIdentifier: "TableViewCell")
            categoryAndScheduleTableView.dataSource = self
            categoryAndScheduleTableView.delegate = self
        }
    
    private func setupCollectionView() {
        collectionView.register(CreateNewTrackerCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(CreateNewTrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupTextField() {
        hobbyNameTextField.delegate = self
    }
    
    private func addViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(titileHobbyLabel)
        view.addSubview(scrollView)
        view.addSubview(bottomButtonsStack)
        setupTitle()
        setupScrollViewItems()
        setupBottomButtonsStack()
    }
    
    private func setupBottomButtonsStack() {
        bottomButtonsStack.addArrangedSubview(cancelButton)
        bottomButtonsStack.addArrangedSubview(createButton)
    }
    
    private func setupScrollViewItems() {
        scrollView.addSubview(hobbyNameTextField)
        scrollView.addSubview(categoryAndScheduleTableView)
        scrollView.addSubview(collectionView)
        
    }
    
    func createNewTracker() -> [TrackerCategory] {
        guard let categories = trackerViewController?.categories,
              let trackerColor = trackerColor,
              let trackerName = trackerName,
              let trackerEmoji = trackerEmoji else { return [] }

        
        let newTracker = Tracker(id: UUID(),
                                 name: trackerName,
                                 color: trackerColor,
                                 emoji: trackerEmoji,
                                 schedule: schedule)

        var newCategory: [TrackerCategory] = []

        categories.forEach { category in
            if selectedCategory == category.name {
                var newTrackers = category.trackerArray
                newTrackers.append(newTracker)
                newCategory.append(TrackerCategory(name: category.name, trackerArray: newTrackers))
            } else {
                newCategory.append(category)
            }
        }

        return newCategory
    }
    
    
//MARK: - Constraints
    private func addConstant() {
        if typeOfTracker == .hobby {
            NSLayoutConstraint.activate([
                categoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: 149)
            ])
        } else {
            NSLayoutConstraint.activate([
                categoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: 75)
            ])
            categoryAndScheduleTableView.separatorStyle = .none
        }
        
        NSLayoutConstraint.activate([
            titileHobbyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titileHobbyLabel.heightAnchor.constraint(equalToConstant: 22),
            titileHobbyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titileHobbyLabel.bottomAnchor, constant: 14),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtonsStack.topAnchor, constant: -16),
//            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            hobbyNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 39),
            hobbyNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hobbyNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hobbyNameTextField.heightAnchor.constraint(equalToConstant: 75),
//            hobbyNameTextField.bottomAnchor.constraint(equalTo: categoryAndScheduleTableView.topAnchor, constant: 34),
            
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: hobbyNameTextField.bottomAnchor, constant: 24),
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
//            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            bottomButtonsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
    
    
    private func setupTitle() {
        titileHobbyLabel.text = typeOfTracker == .hobby ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    @objc private func switchToCategoryViewController() {
        let categoryVC = CategoryViewController()
        present(categoryVC, animated: true)
    }
    
    @objc private func switchToScheduleViewController() {
        let scheduleVC = ScheduleViewController()
        present(scheduleVC, animated: true)
    }
    
}


extension CreateNewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerName = textField.text
//        checkCreateButton()
    }
}


//MARK: - UITableViewDataSource
extension CreateNewTrackerViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeOfTracker {
        case .hobby:
            return 2
        case .irregular:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? CreateNewTrackerTableVIewCell else { return UITableViewCell() }
        cell.label.text = tableViewTitle[indexPath.row]
        
        switch indexPath.row {
        case 0:
            if let selectedCategory = selectedCategory {
                cell.label.removeConstraints(cell.label.constraints)
                cell.configureCellWithCategory(selectedCategory)
            } else {
                cell.configureCellWithoutCategory()
            }
        case 1:
            if let selectedSchedule = selectedSchedule {
                cell.label.removeConstraints(cell.label.constraints)
                cell.configureCellWithCategory(selectedSchedule)
            } else {
                cell.configureCellWithoutCategory()
            }
        default:
            cell.configureCellWithoutCategory()
        }
        
        return cell
    }
}


//MARK: - UITableViewDelegate
extension CreateNewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            switchToCategoryViewController()
        case IndexPath(row: 1, section: 0):
            switchToScheduleViewController()
        default:
            return
        }
    }
}


//MARK: - UICollectionViewDataSource
extension CreateNewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojies.count
        case 1:
            return colors.count
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CreateNewTrackerCollectionViewCell
              
        switch indexPath.section {
        case 0:
            cell.configureEmojiCell(emoji: emojies[indexPath.row])
            return cell
        case 1:
            cell.configureColorCell(color: colors[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: id,
                                                                         for: indexPath) as? CreateNewTrackerSupplementaryView else { return UICollectionReusableView() }
        switch indexPath.section {
        case 0:
            view.headerLabel.text = "Emoji"
        case 1:
            view.headerLabel.text = "Цвет"
        default:
            view.headerLabel.text = ""
        }
        
        return view
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension CreateNewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 52, height: 52)
        case 1:
            return CGSize(width: 46, height: 46)
        default:
            return CGSize(width: 40, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        default:
            return 14
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        case 1:
            return 11
        default:
            return 25
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 19, bottom: 40, right: 19)
        case 1:
            return UIEdgeInsets(top: 0, left: 22, bottom: 40, right: 22)
        default:
            return UIEdgeInsets(top: 0, left: 19, bottom: 40, right: 19)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateNewTrackerCollectionViewCell else { return }
        
        switch indexPath.section {
        case 0:
            cell.layer.cornerRadius = 16
            cell.backgroundColor = .ypLightGray
            trackerEmoji = cell.emojiLabel.text
        case 1:
            cell.layer.cornerRadius = 11
            cell.layer.borderColor = colors[indexPath.row].withAlphaComponent(0.3).cgColor
            cell.layer.borderWidth = 3
            trackerColor = colors[indexPath.row]
        default:
            cell.backgroundColor = .gray
        }
        
//        checkCreateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateNewTrackerCollectionViewCell else { return }
        
        cell.backgroundColor = .none
        cell.layer.borderWidth = 0
//        checkCreateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        
        return true
    }
}
