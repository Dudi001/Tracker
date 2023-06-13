//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.06.2023.
//

import UIKit




final class TrackerViewController: UIViewController {
    var query: String = ""
    var currentDate = Date()
    private let trackerStorage = TrackerStorageService.shared
    
    var day = 1
    
    lazy var emptyImage: UIImageView = {
        let newImage = UIImageView()
        newImage.translatesAutoresizingMaskIntoConstraints = false
        newImage.image = Resourses.Images.trackerEmptyImage
        return newImage
    }()
    
    lazy var emptyLabel: UILabel = {
       let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.text = "Что будем отслеживать?"
        newLabel.tintColor = .ypBlack
        newLabel.textAlignment = .center
        newLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return newLabel
    }()
    
    lazy var trackerCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .automatic
        picker.datePickerMode = .date
        picker.layer.cornerRadius = 8
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.clipsToBounds = true
        return picker
    }()
    
    lazy var searchTextField: UISearchTextField = {
        let searchItem = UISearchTextField()
        searchItem.translatesAutoresizingMaskIntoConstraints = false
        searchItem.placeholder = "Поиск"
        searchItem.font = .systemFont(ofSize: 17, weight: .regular)
        searchItem.returnKeyType = .search
        searchItem.textColor = .ypBlack
        searchItem.clearButtonMode = .never
        return searchItem
    }()
    
    lazy var cancelButton: UIButton = {
        let cancel = UIButton(type: .system)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.tintColor = .ypBlue
        cancel.setTitle("Отменить", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancel.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancel
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = .ypBlue
        filterButton.tintColor = .white
        filterButton.layer.cornerRadius = 16
        filterButton.setTitle("Фильтры", for: .normal)
        filterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        filterButton.addTarget(self, action: #selector(switchToFilterViewController), for: .touchUpInside)
        return filterButton
    }()
    
    private lazy var searchContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    func checkCellsCount() {
        if trackerStorage.categories.count == 0 {
            filterButton.removeFromSuperview()
            view.addSubview(emptyImage)
            view.addSubview(emptyLabel)
                
            NSLayoutConstraint.activate([

                emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8)
            ])
        } else {
            emptyImage.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            view.addSubview(filterButton)
            
            NSLayoutConstraint.activate([
                filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
                filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                filterButton.heightAnchor.constraint(equalToConstant: 50),
                filterButton.widthAnchor.constraint(equalToConstant: 114)
            ])
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTracker()
        addViews()
        setupViews()
        checkCellsCount()
        searchTextField.delegate = self
        query = searchTextField.text ?? ""
        addConstraintSearchText()
        addConstraintsDatePicker()
        setupDatePicker()
        updateVisibleCategories(trackerStorage.categories)
        addConstraintsCollectionView()
    }
    
    
    private func addTracker() {
        if let navBar = navigationController?.navigationBar {
            let addButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addTrackerButton)
            )
            addButton.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(addButton, animated: false)
        }
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(setupTrackersFromDatePicker(_:)), for: .valueChanged)
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        datePicker.calendar = calendar
    }
    
    private func setupCounterTextLabel(trackerID: UUID) -> String {
        let count = trackerStorage.completedTrackers.filter { $0.id == trackerID }.count
//        let lastDigit = count % 10
        var text: String
        text = count.days()
        return("\(text)")
    }
    
    private func setupViews() {
        trackerCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCollectionViewCell")
        trackerCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
    }
    
    private func setupCell(_ cell: TrackerCollectionViewCell, trackerModel: Tracker) {
        cell.emojiLabel.text = trackerModel.emoji
        cell.cellView.backgroundColor = trackerModel.color
        cell.trackerCompleteButton.backgroundColor = trackerModel.color
        cell.trackerCompleteButton.addTarget(self, action: #selector(completeButtonTapped(_:)), for: .touchUpInside)
        let trackerRecord = createTrackerRecord(with: trackerModel.id)
        let isCompleted = trackerStorage.completedTrackers.contains(trackerRecord)
        cell.counterDayLabel.text = setupCounterTextLabel(trackerID: trackerRecord.id)
        if Date() < currentDate && !trackerModel.schedule.isEmpty {
            cell.trackerCompleteButton.isUserInteractionEnabled = false
        } else {
            cell.trackerCompleteButton.isUserInteractionEnabled = true
        }
        cell.trackerCompleteButton.toggled = isCompleted

    }
    
    private func createTrackerRecord(with id: UUID) -> TrackerRecord {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: currentDate)
        let trackerRecord = TrackerRecord(id: id, date: date)
        return trackerRecord
    }
    
    @objc
    private func addTrackerButton() {
        let selectVC = SelectTypeTrackerViewController()
        searchTextField.endEditing(true)
        present(selectVC, animated: true)
    }
    
    @objc
    private func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
    
    @objc
    private func completeButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? TrackerCollectionViewCell,
              let indexPath = trackerCollectionView.indexPath(for: cell) else { return }
        let tracker = trackerStorage.visibleCategories[indexPath.section].trackerArray[indexPath.item]
        guard currentDate < Date() || tracker.schedule.isEmpty else { return }
        let trackerRecord = createTrackerRecord(with: tracker.id)
        if trackerStorage.completedTrackers.contains(trackerRecord) {
            trackerStorage.completedTrackers.remove(trackerRecord)
        } else {
            trackerStorage.completedTrackers.insert(trackerRecord)
        }
        cell.counterDayLabel.text = setupCounterTextLabel(trackerID: tracker.id)
    }
    
    @objc
    private func setupTrackersFromDatePicker(_ sender: UIDatePicker) {
        currentDate = sender.date
        let calendar = Calendar.current
        let weekday: Int = {
            let day = calendar.component(.weekday, from: currentDate) - 1
            if day == 0 { return 7 }
            return day
        }()
        day = weekday
        filtered()
    }
    
    @objc
    private func switchToFilterViewController() {
        let filterVC = FilterViewController()
        present(filterVC, animated: true)
    }
}


extension TrackerViewController {
    private func setupSearchContainerView() {
        searchContainerView.addArrangedSubview(searchTextField)
        searchContainerView.addArrangedSubview(cancelButton)
        cancelButton.isHidden = true
    }
    
    
    private func addViews() {
        guard let navBar = navigationController?.navigationBar else { return }
        setupSearchContainerView()
        view.backgroundColor = .ypWhite
        view.addSubview(trackerCollectionView)
        view.addSubview(datePicker)
        view.addSubview(searchContainerView)
        navBar.addSubview(datePicker)
    }
    
    
    
    private func updateVisibleCategories(_ newCategory: [TrackerCategory]) {
        trackerStorage.visibleCategories = newCategory
        trackerCollectionView.reloadData()
    }
    
    
    private func addConstraintsCollectionView() {
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 10),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addConstraintSearchText() {
        NSLayoutConstraint.activate([
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            
            cancelButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor)
        ])
    }
    
    private func addConstraintsDatePicker() {
        guard let navBar = navigationController?.navigationBar else { return }
        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 97),
            datePicker.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -11)
        ])
    }
    
}


//MARK: - UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let queryTextFiled = textField.text else { return }
        query = queryTextFiled
        filtered()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.isHidden = true
            self.view.layoutIfNeeded()
            
        }
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStorage.visibleCategories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStorage.visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCollectionViewCell", for: indexPath) as! TrackerCollectionViewCell
        let tracker = trackerStorage.visibleCategories[indexPath.section].trackerArray[indexPath.item]
        setupCell(cell, trackerModel: tracker)
        return cell
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
                                                                         for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        view.titleLabel.text = trackerStorage.categories[indexPath.section].name
    
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 41) / 2
//        let height = width * 0.8
        return CGSize(width: width, height: 158)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}


//MARK: - Filters cells

extension TrackerViewController {
    
    private func filtered() {
        var filteredCategories = [TrackerCategory]()
        
        for category in trackerStorage.categories {
            var trackers = [Tracker]()
            for tracker in category.trackerArray {
                let schedule = tracker.schedule
                if schedule.contains(day) {
                    trackers.append(tracker)
                } else if schedule.isEmpty {
                    trackers.append(tracker)
                }
                
            }
            if !trackers.isEmpty {
                let trackerCategory = TrackerCategory(name: category.name, trackerArray: trackers)
                filteredCategories.append(trackerCategory)
            }
        }
        
        if !query.isEmpty {
            var trackersWithFilteredName = [TrackerCategory]()
            for category in filteredCategories {
                var trackers = [Tracker]()
                for tracker in category.trackerArray {
                    let trackerName = tracker.name.lowercased()
                    if trackerName.range(of: query, options: .caseInsensitive) != nil {
                        trackers.append(tracker)
                    }
                }
                if !trackers.isEmpty {
                    let trackerCategory = TrackerCategory(name: category.name, trackerArray: trackers)
                    trackersWithFilteredName.append(trackerCategory)
                }
            }
            filteredCategories = trackersWithFilteredName
        }
        updateVisibleCategories(filteredCategories)
    }
}

