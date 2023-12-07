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

    var query: String = "" {
        didSet {
            setupStandardPlaceholder()
        }
    }
    var currentDate = Date()
    var datePicker: UIDatePicker?
    private let dataProvider = DataProvider.shared
    private lazy var analyticsService = AnalyticsService()
    
    var day = 1
    
    private lazy var emptyImage: UIImageView = {
        let newImage = UIImageView()
        newImage.translatesAutoresizingMaskIntoConstraints = false
        newImage.image = Resourses.Images.trackerEmptyImage
        return newImage
    }()
    
    private lazy var emptyLabel: UILabel = {
       let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.text = NSLocalizedString("placeholder.title", comment: "placeholder title")
        newLabel.tintColor = .ypBlack
        newLabel.textAlignment = .center
        newLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return newLabel
    }()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchItem = UISearchTextField()
        searchItem.translatesAutoresizingMaskIntoConstraints = false
        searchItem.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("trackers.searchTextField.placeholder", comment: ""))
        searchItem.font = .systemFont(ofSize: 17, weight: .regular)
        searchItem.returnKeyType = .search
        searchItem.textColor = .ypBlack
        searchItem.clearButtonMode = .never
        return searchItem
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancel = UIButton(type: .system)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.tintColor = .ypBlue
        cancel.setTitle(NSLocalizedString("trackers.cancelButton.title", comment: ""), for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancel.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancel
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = .ypBlue
        filterButton.tintColor = .white
        filterButton.layer.cornerRadius = 16
        filterButton.setTitle(NSLocalizedString("filter.button.title", comment: ""), for: .normal)
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
        updateVisibleCategories(dataProvider.categories)
        initialDay()
        dataProvider.delegate = self
        dataProvider.updateRecords()
        searchTextField.delegate = self
        query = searchTextField.text ?? ""
        addViews()
        setupViews()
        addConstraintSearchText()
        addConstraintsCollectionView()
        setupDatePicker()
//        checkCellsCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.reportScreen(event: .open, onScreen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.reportScreen(event: .close, onScreen: .main)
    }
    
    private func addViews() {
        setupSearchContainerView()
        view.backgroundColor = .ypWhite
        view.addSubview(trackerCollectionView)
        view.addSubview(searchContainerView)
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
            emptyImage.image = Resourses.Images.trackerEmptyImage
            emptyLabel.text = NSLocalizedString("placeholder.title", comment: "placeholder title")
            
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

    private func setupViews() {
        trackerCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCollectionViewCell")
        trackerCollectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "head")
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
    
    func presentSelectTypeVC() {
        let selectVC = SelectTypeTrackerViewController()
        selectVC.trackerViewController = self
        searchTextField.endEditing(true)
        present(selectVC, animated: true)
    }
    
    private func setupDatePicker() {
        datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        datePicker?.calendar = calendar
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        let calendar = Calendar.current
        let weekday: Int = {
            let day = calendar.component(.weekday, from: currentDate)
            if day == 0 { return 7 }
            return day
        }()
        day = weekday
        filtered()
        setupStandardPlaceholder()
    }
    
    
    private func setupStandardPlaceholder() {
        if searchTextField.text == "" {
            emptyImage.image = Resourses.Images.trackerEmptyImage
            emptyLabel.text = NSLocalizedString("placeholder.title", comment: "placeholder title")
        } else {
            setupPlaceHolder()
        }
    }
    
    private func setupPlaceHolder() {
        if dataProvider.visibleCategories.isEmpty  {
            emptyImage.image = Resourses.Images.arrayEmptyImage
            emptyLabel.text = NSLocalizedString("trackers.notFoundPlaceholder.title", comment: "")
        }
    }
    
//MARK: - @OBJC FUNC
    
    
    
    @objc
    private func completeButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? TrackerCollectionViewCell,
              let indexPath = trackerCollectionView.indexPath(for: cell) else { return }
        
        let tracker = dataProvider.visibleCategories[indexPath.section].trackerArray[indexPath.item]
        
        guard currentDate < Date() || tracker.schedule.isEmpty else { return }
        
        let trackerRecord = createTrackerRecord(with: tracker.id)
        
        if dataProvider.completedTrackers.contains(trackerRecord) {
            dataProvider.deleteRecord(trackerRecord)
        } else {
            dataProvider.addRecord(trackerRecord)
        }
        cell.counterDayLabel.text = setupCounterTextLabel(trackerID: tracker.id)
        analyticsService.report(event: .click, screen: .main, item: .track)
    }
    
    private func setupCounterTextLabel(trackerID: UUID) -> String {
        let count = dataProvider.completedTrackers.filter { $0.id == trackerID }.count
        var text: String
        text = count.days()
        return("\(text)")
    }
    
    private func initialDay() {
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


//MARK: - Constraints
extension TrackerViewController {
    private func setupSearchContainerView() {
        searchContainerView.addArrangedSubview(searchTextField)
        searchContainerView.addArrangedSubview(cancelButton)
        cancelButton.isHidden = true
    }
    
    func updateVisibleCategories(_ newCategories: [TrackerCategory]) {
        dataProvider.visibleCategories = newCategories
        trackerCollectionView.reloadData()
        updateCollectionViewVisibility()
//        setEmptyImage()
    }
    
    private func updateCollectionViewVisibility() {
        let hasData = !dataProvider.visibleCategories.isEmpty
        trackerCollectionView.isHidden = !hasData
        emptyImage.isHidden = hasData
    }
    
    private func setEmptyImage() {
        if dataProvider.visibleCategories.isEmpty {
            setEmptyItemsAfterSearch()
        } else {
            emptyImage.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            trackerCollectionView.reloadData()
            trackerCollectionView.alpha = 1
        }
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
        let menu = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(menu)
        let tracker = dataProvider.visibleCategories[indexPath.section].trackerArray[indexPath.item]
        setupCell(cell, trackerModel: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "head"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath) as? SupplementaryView
        else { return UICollectionReusableView() }
        
        if !dataProvider.visibleCategories[indexPath.section].trackerArray.isEmpty {
            view.titleLabel.text = dataProvider.visibleCategories[indexPath.section].header
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
    
}


//MARK: - Filters cells
extension TrackerViewController {
    
    func setEmptyItemsAfterSearch() {
        trackerCollectionView.alpha = 0

        view.addSubview(emptyImage)
        view.addSubview(emptyLabel)
        
        emptyImage.image = Resourses.Images.arrayEmptyImage
        emptyLabel.text = NSLocalizedString("trackers.notFoundPlaceholder.title", comment: "")

        NSLayoutConstraint.activate([

            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8)
        ])
    }
   
    
    private func filtered() {
        var filteredCategories = [TrackerCategory]()
        var pinnedTrackers = [Tracker]()
        
        for category in dataProvider.categories {
            var trackers = [Tracker]()
            for tracker in category.trackerArray {
                let schedule = tracker.schedule
                if schedule.contains(day) {
                    if tracker.pinned {
                        pinnedTrackers.append(tracker)
                    } else {
                        trackers.append(tracker)
                    }
                } else if schedule.isEmpty {
                    if tracker.pinned {
                        pinnedTrackers.append(tracker)
                    } else {
                        trackers.append(tracker)
                    }
                }
            }
            if !trackers.isEmpty {
                let trackerCategory = TrackerCategory(header: category.header, trackerArray: trackers)
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
                        if tracker.pinned {
                            pinnedTrackers.append(tracker)
                        } else {
                            trackers.append(tracker)
                        }
                    }
                }
                if !trackers.isEmpty {
                    let trackerCategory = TrackerCategory(header: category.header, trackerArray: trackers)
                    trackersWithFilteredName.append(trackerCategory)
                }
            }
            filteredCategories = trackersWithFilteredName
        }
        
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(header: "Закрепленные", trackerArray: pinnedTrackers)
            filteredCategories.insert(pinnedCategory, at: 0)
        }
        
        updateVisibleCategories(filteredCategories)
    }

    
//MARK: - FILTER @OBJC FUNC
    @objc
    private func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
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
        filtered()
        dismissAllModalControllers(from: self)
    }
    
    func updateCategories(_ newCategory: [TrackerCategory]) {
        dataProvider.categories = newCategory
        updateVisibleCategories(dataProvider.categories)
        
    }
    
    func updateRecords(_ newRecords: Set<TrackerRecord>) {
        dataProvider.completedTrackers = newRecords
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
        setupStandardPlaceholder()
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
        
        if dataProvider.visibleCategories.isEmpty  {
            emptyImage.image = Resourses.Images.arrayEmptyImage
            emptyLabel.text = NSLocalizedString("trackers.notFoundPlaceholder.title", comment: "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}


//MARK: - UIContextMenuInteractionDelegate

extension TrackerViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let cell = interaction.view as? TrackerCollectionViewCell else {
            return nil
        }
        
        guard let indexPath = trackerCollectionView.indexPath(for: cell) else {
            return nil
        }
        let category = dataProvider.visibleCategories[indexPath.section]
        let tracker = category.trackerArray[indexPath.item]
        let pinTitle = tracker.pinned ? NSLocalizedString("contextMenu.unpin", comment: "") : NSLocalizedString("contextMenu.pin", comment: "")
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            
            let pickAction = UIAction(title: pinTitle, image: nil, identifier: nil) { _ in
                self.pinTracker(at: indexPath)
            }
            let editAction = UIAction(title: NSLocalizedString("contextMenu.edit", comment: ""), image: nil, identifier: nil) { _ in
                self.analyticsService.report(event: .click, screen: .main, item: .edit)
                self.editTracker(at: indexPath)
            }
            let deleteAction = UIAction(title: NSLocalizedString("contextMenu.delete", comment: ""), image: nil, identifier: nil) { _ in
                self.analyticsService.report(event: .click, screen: .main, item: .delete)
                self.showDeleteAlert(at: indexPath)
            }
            deleteAction.attributes = .destructive
            let menu = UIMenu(title: "", children: [pickAction, editAction, deleteAction])
            return menu
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let cell = interaction.view as? UICollectionViewCell else {
            return nil
        }
        
        let highlightedArea = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height - 61)
        let cornerRadius: CGFloat = 16.0
        let roundedPath = UIBezierPath(roundedRect: highlightedArea, cornerRadius: cornerRadius)
        let parameters = UIDragPreviewParameters()
        parameters.visiblePath = roundedPath
        
        let targetedPreview = UITargetedPreview(view: cell, parameters: parameters)
        return targetedPreview
    }
    
    private func editTracker(at indexPath: IndexPath) {
        let category = dataProvider.visibleCategories[indexPath.section]
        let tracker = category.trackerArray[indexPath.item]
        let isEvent = tracker.schedule.isEmpty
        let counterText = setupCounterTextLabel(trackerID: tracker.id)
        present(EditTrackerViewController(
            type: isEvent ? .event : .habits,
            tracker: tracker,
            counterHeaderText: counterText,
            category: category.header), animated: true)
    }
    
    private func pinTracker(at indexPath: IndexPath) {
        let category = dataProvider.visibleCategories[indexPath.section]
        let tracker = category.trackerArray[indexPath.item]
        
        dataProvider.pinTracker(model: tracker)
        filtered()
    }
    
    private func deleteTracker(at indexPath: IndexPath) {
        let category = dataProvider.visibleCategories[indexPath.section]
        let tracker = category.trackerArray[indexPath.item]
        
        dataProvider.deleteTracker(model: tracker)
        filtered()
    }
    
    private func showDeleteAlert(at indexPath: IndexPath) {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("deleteAlert.text", comment: ""),
                                      preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("deleteAlert.cancelAction.text", comment: ""), style: .cancel)
        let deleteAction = UIAlertAction(title: NSLocalizedString("deleteAlert.deleteAction.text", comment: ""), style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.deleteTracker(at: indexPath)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}
