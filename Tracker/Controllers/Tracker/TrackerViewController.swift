//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.06.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    private var query: String = ""
    private var currentDate = Date()
    private var completedTrackers: Set<TrackerRecord> = []
    private var day = 1
    
    private lazy var testTrakers: [Tracker] = [
        Tracker(id: UUID(), name: "Тест 1", color: .colorSelection1, emoji: "🐕", schedule:  []),
            Tracker(id: UUID(), name: "Попрыгать ", color: .colorSelection2, emoji: "😇", schedule: []),
            Tracker(id: UUID(), name: "Сделать сальтуху", color: .colorSelection3, emoji: "🍒", schedule: []),


        ]

    private lazy var secondTrackers: [Tracker] = [
        Tracker(id: UUID(), name: "тест2", color: .colorSelection4, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "тест3333", color: .colorSelection6, emoji: "🦒", schedule: []),
        Tracker(id: UUID(), name: "Накоримить уток", color: .colorSelection7, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "Найти жирафа", color: .colorSelection5, emoji: "🦒", schedule: []),
        Tracker(id: UUID(), name: "Накоримить уток", color: .colorSelection8, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "Найти жирафа", color: .colorSelection9, emoji: "🦒", schedule: []),
    ]
    private lazy var categories: [TrackerCategory] = [
        TrackerCategory(name: "Заголовок1", trackerArray: testTrakers),
        TrackerCategory(name: "Заголовок2", trackerArray: secondTrackers)
    ]
    
    
    private lazy var visibleCategories = [TrackerCategory]()
    
    lazy var emptyImage: UIImageView = {
        let newImage = UIImageView()
        newImage.image = Resourses.Images.trackerEmptyImage
        return newImage
    }()
    
    lazy var emptyLabel: UILabel = {
       let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.text = "что будем отслеживать?"
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
    
    private lazy var searchContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
//    private lazy var placeholder: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.image = .placeHolder
//        return image
//    }()
//
//    private func setupPlaceHolder() {
//        if visibleCategories.isEmpty  {
//            placeholder.image = .notFound
//            emptyLabel.text = "Ничего не найдено"
//        }
//    }
    
    
    func checkCellsCount() {
        if categories.count == 0 {
            
            view.addSubview(emptyImage)
            view.addSubview(emptyLabel)
                
            NSLayoutConstraint.activate([
//                emptyImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
                emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8)
            ])
        } else {
            emptyImage.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            }
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTracker()
        addViews()
        setupViews()
//        setupPlaceHolder()
        checkCellsCount()
        searchTextField.delegate = self
        query = searchTextField.text ?? ""
        addConstraintSearchText()
        addConstraintsDatePicker()
        setupDatePicker()
        updateVisibleCategories(categories)
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
        let count = completedTrackers.filter { $0.id == trackerID }.count
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
        let isCompleted = completedTrackers.contains(trackerRecord)
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
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.item]
        guard currentDate < Date() || tracker.schedule.isEmpty else { return }
        let trackerRecord = createTrackerRecord(with: tracker.id)
        if completedTrackers.contains(trackerRecord) {
            completedTrackers.remove(trackerRecord)
        } else {
            completedTrackers.insert(trackerRecord)
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
//        filtered()
//        setupPlaceHolder()
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
        visibleCategories = newCategory
        trackerCollectionView.reloadData()
//        updateCollectionViewVisibility()
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
//            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 10),
            
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
//        filtered()
//        setupPlaceHolder()
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
        
//        if categories.isEmpty {
////            placeholder.image = .placeHolder
//            emptyLabel.text = "Что будем отслеживать?"
//        }

    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCollectionViewCell", for: indexPath) as! TrackerCollectionViewCell
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.item]
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
        view.titleLabel.text = categories[indexPath.section].name
    
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