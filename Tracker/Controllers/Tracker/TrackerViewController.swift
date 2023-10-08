//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.06.2023.
//

import UIKit

protocol TrackerViewControllerProtocol: AnyObject {
    func reloadCollectionView()
    func checkCellsCount()
    func updateVisibleCategories(_ newCategories: [TrackerCategory])
}


final class TrackerViewController: UIViewController, TrackerViewControllerProtocol {
    var query: String = ""
    var currentDate = Date()
    private let dataProvider = DataProvider.shared
    
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
        picker.addTarget(self, action: #selector(setupTrackersFromDatePicker), for: .valueChanged)
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
        searchItem.addTarget(self, action: #selector(setupTrackersFromTextField), for: .editingChanged)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.setMainCategory()
        dataProvider.categories = dataProvider.getTrackers()
        dataProvider.updateRecords()
        addTracker()
        addViews()
        setupViews()
        checkCellsCount()
        dataProvider.delegate = self
        searchTextField.delegate = self
        query = searchTextField.text ?? ""
        addConstraintSearchText()
        addConstraintsDatePicker()
        updateVisibleCategories(dataProvider.categories)
        addConstraintsCollectionView()
        setupTrackersFromDatePicker()
    }
    
    func reloadCollectionView() {
        dataProvider.visibleCategories = dataProvider.categories
        trackerCollectionView.reloadData()
    }
    
    func checkCellsCount() {
        if dataProvider.categories.count == 0 {
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
    
//MARK: - Private func
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

    private func setupViews() {
        trackerCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCollectionViewCell")
        trackerCollectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header")
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
    }
    
    private func createTrackerRecord(with id: UUID) -> TrackerRecord {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: currentDate)
        let trackerRecord = TrackerRecord(id: id, date: date)
        return trackerRecord
    }
    
//MARK: - @OBJC FUNC
    @objc
    private func addTrackerButton() {
        let selectVC = SelectTypeTrackerViewController()
        selectVC.trackerViewController = self
        searchTextField.endEditing(true)
        present(selectVC, animated: true)
    }
    
    
    @objc
    private func completeButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? TrackerCollectionViewCell,
              let indexPath = trackerCollectionView.indexPath(for: cell) else { return }
        
        let tracker = dataProvider.visibleCategories[indexPath.section].trackerArray[indexPath.item]
        
        guard currentDate < Date() || tracker.schedule.isEmpty else { return }
        
        let trackerRecord = createTrackerRecord(with: tracker.id)
        
        if dataProvider.completedTrackers.contains(trackerRecord) {
            dataProvider.completedTrackers.remove(trackerRecord)
        } else {
            dataProvider.completedTrackers.insert(trackerRecord)
        }
        cell.counterDayLabel.text = setupCounterTextLabel(trackerID: tracker.id)
    }
    
    private func setupCounterTextLabel(trackerID: UUID) -> String {
        let count = dataProvider.completedTrackers.filter { $0.id == trackerID }.count
        var text: String
        text = count.days()
        return("\(text)")
    }
    
    
    @objc
    private func switchToFilterViewController() {
        let filterVC = FilterViewController()
        present(filterVC, animated: true)
    }
}


//MARK: - Constraints
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
    
    
    
    func updateVisibleCategories(_ newCategories: [TrackerCategory]) {
        dataProvider.currentDate = datePicker.date
        let newTrackerCategory = dataProvider.showNewTrackersAfterChanges(newCategories)
        
        if dataProvider.visibleCategories.isEmpty {
            setEmptyItemsAfterSearch()
        } else {
            emptyImage.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            trackerCollectionView.reloadData()
            trackerCollectionView.alpha = 1
        }
        
        
        dataProvider.visibleCategories = newTrackerCategory
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


//MARK: - CollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataProvider.visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataProvider.visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCollectionViewCell", for: indexPath) as! TrackerCollectionViewCell
        let tracker = dataProvider.visibleCategories[indexPath.section].trackerArray[indexPath.item]
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
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath) as? SupplementaryView
        else { return UICollectionReusableView() }
        
        if !dataProvider.visibleCategories[indexPath.section].trackerArray.isEmpty {
            view.titleLabel.text = dataProvider.visibleCategories[indexPath.section].name
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: collectionView.frame.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    private func setupCell(_ cell: TrackerCollectionViewCell, trackerModel: Tracker) {
        cell.emojiLabel.text = trackerModel.emoji
        cell.textTrackerLabel.text = trackerModel.name
        cell.cellView.backgroundColor = trackerModel.color
        cell.trackerCompleteButton.backgroundColor = trackerModel.color
        cell.trackerCompleteButton.addTarget(self, action: #selector(completeButtonTapped(_:)), for: .touchUpInside)
        
        let trackerRecord = createTrackerRecord(with: trackerModel.id)
        let isCompleted = dataProvider.completedTrackers.contains(trackerRecord)

        cell.counterDayLabel.text = setupCounterTextLabel(trackerID: trackerRecord.id)        
        
        if Date() < currentDate && !trackerModel.schedule.isEmpty {
            cell.trackerCompleteButton.isUserInteractionEnabled = false
        } else {
            cell.trackerCompleteButton.isUserInteractionEnabled = true
        }
        cell.trackerCompleteButton.toggled = isCompleted
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 9) / 2
        let height = width * 0.887
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
//    }
    
}


//MARK: - Filters cells
extension TrackerViewController {
    
    func setEmptyItemsAfterSearch() {
        trackerCollectionView.alpha = 0

        view.addSubview(emptyImage)
        view.addSubview(emptyLabel)
        
        emptyImage.image = Resourses.Images.arrayEmptyImage
        emptyLabel.text = "Что будем отслеживать?"

        NSLayoutConstraint.activate([

            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8)
        ])
    }
    
    func searchTrackerByName(categories: [TrackerCategory], filledName: String) -> [TrackerCategory] {
        var newVisibleArray: [TrackerCategory] = []
        
        for category in categories {
            var newCategory = TrackerCategory(name: category.name, trackerArray: [])
            
            for tracker in category.trackerArray {
                if tracker.name.contains(filledName) {
                    newCategory.trackerArray.append(tracker)
                }
            }
            
            if !newCategory.trackerArray.isEmpty {
                newVisibleArray.append(newCategory)
            }
        }
        
        return newVisibleArray
    }
    
//MARK: - FILTER @OBJC FUNC
    @objc
    private func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        updateVisibleCategories(dataProvider.categories)
        emptyImage.removeFromSuperview()
        emptyLabel.removeFromSuperview()
        trackerCollectionView.reloadData()
        trackerCollectionView.alpha = 1

    }
    
    @objc
    private func setupTrackersFromDatePicker() {
        currentDate = datePicker.date
        updateVisibleCategories(dataProvider.categories)
        trackerCollectionView.reloadData()
    }
    
    @objc
    private func setupTrackersFromTextField() {
        guard let text = searchTextField.text else { return }
        let categories = dataProvider.visibleCategories
        
        let newCategory = searchTrackerByName(categories: categories, filledName: text)
        
        if newCategory.count == 0 {
            setEmptyItemsAfterSearch()
        }
        
        dataProvider.visibleCategories = newCategory
        trackerCollectionView.reloadData()
    }
    
    private func dismissAllModalControllers(from viewController: UIViewController) {
        if let presentedViewController = viewController.presentedViewController {
            viewController.dismiss(animated: true, completion: nil)
            dismissAllModalControllers(from: presentedViewController)
        }
    }
}


//MARK: - DataProviderDelegate

extension TrackerViewController: DataProviderDelegate {
    func addTrackers() {
        updateVisibleCategories(dataProvider.categories)
        dismissAllModalControllers(from: self)
    }
    
    func updateCategories(_ newCategory: [TrackerCategory]) {
        dataProvider.categories = newCategory
        updateVisibleCategories(dataProvider.categories)
        
    }
    
    func updateRecords(_ newRecord: Set<TrackerRecord>) {
        dataProvider.completedTrackers = newRecord
    }
}
