
import UIKit


final class EditTrackerViewController: UIViewController, CreateTrackerViewControllerProtocol {
    var typeOfTracker: TypeOfTracker?
    var newCategory: [TrackerCategory] = []
    var selecTypeTracker: SelectTypeTrackerViewControllerProtocol?
    private var dataProvider = DataProvider.shared
    private lazy var trackerStore = TrackerStore()
    weak var delegate: DataProviderDelegate?
    private var tracker: Tracker
    private var counterHeaderText: String
    private var category: String
    var type: `Type`
    
    private var selectedEmojiIndexPatch: IndexPath?
    private var selectedColorIndexPatch: IndexPath?
    
    enum `Type` {
            case habits
            case event
    
            var arrayOfButtons: [String] {
                switch self {
                case .habits: return [NSLocalizedString("createTracker.button.category", comment: ""),
                                      NSLocalizedString("createTracker.button.schedule", comment: "")]
                case .event: return [NSLocalizedString("createTracker.button.category", comment: "")]
                }
            }
        }
     
    init(type: Type, tracker: Tracker, counterHeaderText: String, category: String) {
            self.type = type
            self.tracker = tracker
            self.counterHeaderText = counterHeaderText
            self.category = category
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fillTrackerData() {
        textField.text = tracker.name
        dataProvider.title = tracker.name
        dataProvider.emoji = tracker.emoji
        dataProvider.color = tracker.color
        dataProvider.schedule = tracker.schedule
        dataProvider.category = category
        
        if let emojiIndex = dataProvider.emojies.firstIndex(of: tracker.emoji) {
            let emojiIndexPath = IndexPath(row: emojiIndex, section: 0)
            collectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            selectedEmojiIndexPatch = emojiIndexPath
        }
        
        if let colorIndex = dataProvider.colors.firstIndex(of: tracker.color) {
            let colorIndexPath = IndexPath(row: colorIndex, section: 0)
            collectionView.selectItem(at: colorIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            selectedColorIndexPatch = colorIndexPath
        }
        checkCreateButton()
    }
    
    private func createButtonPressedIsEnabled() {
        if DataProvider.shared.updateButtonEnabled() {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypWhite
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
    
    private lazy var titileHobbyLabel: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        text.textColor = .ypBlack
        return text
    }()
    
    
    private lazy var textField: UITextField = {
       let hobbyText = UITextField()
        hobbyText.placeholder = "Введите название трекера"
        hobbyText.backgroundColor = .ypBackground
        hobbyText.textColor = .ypBlack
        hobbyText.clearButtonMode = .whileEditing
        hobbyText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        hobbyText.leftViewMode = .always
        hobbyText.returnKeyType = .done
        hobbyText.layer.cornerRadius = 16
        hobbyText.font = .systemFont(ofSize: 17, weight: .regular)
        hobbyText.translatesAutoresizingMaskIntoConstraints = false
        return hobbyText
    }()
    
    private lazy var warningLabel: UILabel = {
        let element = UILabel()
        element.text = "Ограничение 38 символов"
        element.font = .systemFont(ofSize: 17, weight: .regular)
        element.textColor = .ypRed
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var categoryAndScheduleTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .singleLine
        element.layer.cornerRadius = 16
        element.isScrollEnabled = false
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var collectionView: UICollectionView = {
        let element = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        element.backgroundColor = .ypWhite
        element.isScrollEnabled = false
        element.allowsMultipleSelection = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cancelButton: UIButton = {
        let element = UIButton(type: .system)
        element.layer.cornerRadius = 16
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.ypRed.cgColor
        element.setTitle("Отменить", for: .normal)
        element.titleLabel?.textAlignment = .center
        element.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        element.backgroundColor = .ypWhite
        element.tintColor = .ypRed
        element.addTarget(self, action: #selector(cancelButtonActive), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var createButton: UIButton = {
        let element = UIButton(type: .system)
        element.layer.cornerRadius = 16
        element.setTitle("Создать", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        element.setTitleColor(.white, for: .normal)
        element.backgroundColor = .ypGray
        element.isEnabled = false
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return element
    }()
    
    private let bottomButtonsStack: UIStackView = {
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
        setupTextField()
        setupCollectionView()
        fillTrackerData()
        checkCreateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.categoryAndScheduleTableView.reloadData()
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
        textField.delegate = self
    }
    
    
    private func setupTitle() {
        titileHobbyLabel.text = typeOfTracker == .hobby ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    func reloadTableView() {
        categoryAndScheduleTableView.reloadData()
    }
    
    
//MARK: - Constraints
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
        scrollView.addSubview(textField)
        scrollView.addSubview(categoryAndScheduleTableView)
        scrollView.addSubview(collectionView)
        
    }
    
    func enableCreateButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = .ypBlack
        createButton.setTitleColor(.ypWhite, for: .normal)
    }
    
    func disableCreateButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = .ypGray
    }
    
    
    func checkCreateButton() {
        if dataProvider.trackerName != nil &&
            dataProvider.selectedCategory != nil &&
            dataProvider.trackerEmoji != nil &&
            dataProvider.trackerColor != nil {
            switch typeOfTracker {
            case .irregular:
                enableCreateButton()
            case .hobby:
                dataProvider.selectedSchedule != nil ? enableCreateButton() : disableCreateButton()
            default:
                disableCreateButton()
            }
        } else {
            disableCreateButton()
        }
    }
    
//TODO: - Need fix top constraint for tableView
    private func setTextFieldWarning(_ countText: Int?) {
        
        guard let countText = countText else { return }
        if countText >= 38 {
            view.addSubview(warningLabel)
            disableCreateButton()
//            categoryAndScheduleTableView.removeConstraint(topAnchorTableView)
            
            NSLayoutConstraint.activate([
                warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
                warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: -66),
                categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        } else {
            warningLabel.removeFromSuperview()
            
//            NSLayoutConstraint.activate([
//                categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24)
//            ])
        }
    }
    

    
    private func addConstant() {
        let topAnchorTableView = categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24)
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
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 39),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
//            categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            topAnchorTableView,
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),

            bottomButtonsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
    
//MARK: - @OBJC FUNC
    @objc
    private func switchToCategoryViewController() {
        let categoryVC = CategoryViewController()
        categoryVC.createTrackerViewController = self
        present(categoryVC, animated: true)
    }
    
    @objc
    private func switchToScheduleViewController() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.createTrackerViewController = self
        present(scheduleVC, animated: true)
    }
    
    @objc
    private func cancelButtonActive() {
        dismiss(animated: true)
    }
    
    
    @objc
    private func createButtonTapped() {
        dataProvider.trackerName = textField.text
        dataProvider.createTracker()
//        dataProvider.resetNewTrackerInfo()
        dismiss(animated: true)
        selecTypeTracker?.switchToTrackerVC()
    }
}


extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        guard let textCount = textField.text?.count,
              let text = textField.text
        else { return }
        checkCreateButton()
        setTextFieldWarning(textCount)
        dataProvider.trackerName = text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkCreateButton()
        return textField.resignFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard //let textCount = textField.text?.count,
              let text = textField.text
        else { return }
        checkCreateButton()
//        setTextFieldWarning(textCount)
        dataProvider.trackerName = text
    }
}


//MARK: - UITableViewDataSource
extension EditTrackerViewController: UITableViewDataSource {
    
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
        cell.label.text = dataProvider.tableViewTitle[indexPath.row]
        
        switch indexPath.row {
        case 0:
            if let selectedCategory = dataProvider.selectedCategory {
                cell.label.removeConstraints(cell.label.constraints)
                cell.configureCellWithCategory(selectedCategory)
            } else {
                cell.configureCellWithoutCategory()
            }
        case 1:
            if let selectedSchedule = dataProvider.selectedSchedule {
                cell.label.removeConstraints(cell.label.constraints)
                cell.configureCellWithCategory(selectedSchedule)
            } else {
                cell.configureCellWithoutCategory()
            }
        default:
            cell.configureCellWithoutCategory()
        }
        checkCreateButton()
        return cell
    }
}


//MARK: - UITableViewDelegate
extension EditTrackerViewController: UITableViewDelegate {
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
extension EditTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataProvider.emojies.count
        case 1:
            return dataProvider.colors.count
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CreateNewTrackerCollectionViewCell
              
        switch indexPath.section {
        case 0:
            cell.configureEmojiCell(emoji: dataProvider.emojies[indexPath.row])
            return cell
        case 1:
            cell.configureColorCell(color: dataProvider.colors[indexPath.row])
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
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath) as? CreateNewTrackerSupplementaryView
        else { return UICollectionReusableView() }
        
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
extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
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
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: collectionView.frame.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
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
    
    // MARK: - Работа с базой данных. Установка ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateNewTrackerCollectionViewCell else { return }
        
        switch indexPath.section {
        case 0:
            cell.layer.cornerRadius = 16
            cell.backgroundColor = .ypLightGray
            dataProvider.trackerEmoji = cell.emojiLabel.text
        case 1:
            cell.layer.cornerRadius = 11
            cell.layer.borderColor = dataProvider.colors[indexPath.row].withAlphaComponent(0.3).cgColor
            cell.layer.borderWidth = 3
            dataProvider.trackerColor = dataProvider.colors[indexPath.row]
        default:
            cell.backgroundColor = .gray
        }
        checkCreateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateNewTrackerCollectionViewCell else { return }
        
        cell.backgroundColor = .none
        cell.layer.borderWidth = 0
        checkCreateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        checkCreateButton()
        return true
    }
}

//final class EditTrackerViewController: UIViewController {
//    
//    private let dataProvider = DataProvider.shared
//    private var arrayOfButtons: [String] {
//        return type.arrayOfButtons
//    }
//    private var selectedEmojiIndexPatch: IndexPath?
//    private var selectedColorIndexPatch: IndexPath?
//    private var tracker: Tracker
//    private var counterHeaderText: String
//    private var category: String
//    
//    var type: `Type`
//    
//    enum `Type` {
//        case habits
//        case event
//        
//        var arrayOfButtons: [String] {
//            switch self {
//            case .habits: return [NSLocalizedString("createTracker.button.category", comment: ""),
//                                  NSLocalizedString("createTracker.button.schedule", comment: "")]
//            case .event: return [NSLocalizedString("createTracker.button.category", comment: "")]
//            }
//        }
//    }
//    
//    init(type: Type, tracker: Tracker, counterHeaderText: String, category: String) {
//        self.type = type
//        self.tracker = tracker
//        self.counterHeaderText = counterHeaderText
//        self.category = category
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private lazy var headerLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = NSLocalizedString("createTracker.title", comment: "")
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//    
//    private lazy var counterHeader: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = counterHeaderText
//        label.font = UIFont.boldSystemFont(ofSize: 32)
//        return label
//    }()
//    
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//    
//    
//    private lazy var trackerHeaderTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.backgroundColor = .ypWhite
//        textField.textColor = .ypWhite
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
//        textField.leftViewMode = .always
//        textField.placeholder = NSLocalizedString("createTracker.textField.placeholder", comment: "placeholder textfield")
//        textField.text = dataProvider.title
//        
//        textField.layer.cornerRadius = 16
//        return textField
//    }()
//    
//    private lazy var tableView: UITableView = {
//        let table = UITableView(frame: view.bounds)
////        table.register(CreateNewTrackerCollectionViewCell.self, forCellReuseIdentifier: CreateNewTrackerCollectionViewCell.reuseIdentifier)
//        table.layer.cornerRadius = 10
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        return table
//    }()
//    
//    private lazy var emojiesCollectionViewHeaderLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = NSLocalizedString("createTracker.emojiTitle", comment: "")
//        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
//        return label
//    }()
//    
//    private lazy var emojiesCollectionView: UICollectionView = {
//        let element = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        element.backgroundColor = .ypWhite
//        element.isScrollEnabled = false
//        element.allowsMultipleSelection = true
//        element.translatesAutoresizingMaskIntoConstraints = false
//        return element
//    }()
//    
//    private lazy var colorsCollectionViewHeaderLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = NSLocalizedString("createTracker.colorTitle", comment: "")
//        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
//        return label
//    }()
//    
//    private lazy var colorsCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 14
//        layout.minimumInteritemSpacing = 25
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.isScrollEnabled = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    
//    private lazy var cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 16
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.ypRed.cgColor
//        button.setTitle(NSLocalizedString("createTracker.cancelButtonTitle", comment: ""), for: .normal)
//        button.setTitleColor(.ypRed, for: .normal)
//        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
//        return button
//    }()
//    
//    private lazy var saveButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 16
//        button.backgroundColor = .ypGray
//        button.setTitle(NSLocalizedString("editTacker.saveButtonTitle", comment: ""), for: .normal)
//        button.setTitleColor(.ypWhite
//                             , for: .normal)
//        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    let bottomButtonsStack: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 8
//        return stackView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupLayout()
//        setupKeyboard()
//        bind()
//        fillTrackerData()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//    
//    private func fillTrackerData() {
//        trackerHeaderTextField.text = tracker.name
//        dataProvider.title = tracker.name
//        dataProvider.emoji = tracker.emoji
//        dataProvider.color = tracker.color
//        dataProvider.schedule = tracker.schedule
//        dataProvider.category = category
//        
//        if let emojiIndex = dataProvider.emojies.firstIndex(of: tracker.emoji) {
//            let emojiIndexPath = IndexPath(row: emojiIndex, section: 0)
//            emojiesCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//            selectedEmojiIndexPatch = emojiIndexPath
//        }
//        
//        if let colorIndex = dataProvider.colors.firstIndex(of: tracker.color) {
//            let colorIndexPath = IndexPath(row: colorIndex, section: 0)
//            colorsCollectionView.selectItem(at: colorIndexPath, animated: false, scrollPosition: .centeredHorizontally)
//            selectedColorIndexPatch = colorIndexPath
//        }
//        createButtonPressedIsEnabled()
//    }
//    
//    private func setupBottomButtonsStack() {
//        bottomButtonsStack.addArrangedSubview(cancelButton)
//        bottomButtonsStack.addArrangedSubview(saveButton)
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        view.addSubview(headerLabel)
//        view.addSubview(counterHeader)
//        setupScrollView()
//        view.addSubview(scrollView)
//        
//        setupBottomButtonsStack()
//        view.addSubview(bottomButtonsStack)
//        trackerHeaderTextField.delegate = self
//        saveButton.isEnabled = false
//    }
//    
//    private func setupScrollView() {
//        setupEmojiesCollectionView()
//        setupColorsCollectionView()
//        scrollView.addSubview(trackerHeaderTextField)
//        scrollView.addSubview(tableView)
//        scrollView.addSubview(emojiesCollectionViewHeaderLabel)
//        scrollView.addSubview(emojiesCollectionView)
//        scrollView.addSubview(colorsCollectionViewHeaderLabel)
//        scrollView.addSubview(colorsCollectionView)
//    }
//    
//    private func setupEmojiesCollectionView() {
//        emojiesCollectionView.delegate = self
//        emojiesCollectionView.dataSource = self
//        emojiesCollectionView.register(CreateNewTrackerCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//    }
//    
//    private func setupColorsCollectionView() {
//        colorsCollectionView.delegate = self
//        colorsCollectionView.dataSource = self
//    }
//    
//    
//    private func bind() {
//        dataProvider.$category.bind {[weak self] _ in
//            self?.tableView.reloadData()
//        }
//    }
//    
//    @objc
//    private func dismissSelf() {
//        dismiss(animated: true)
//    }
//    
//    @objc
//    private func createButtonPressed() {
//        dataProvider.updateTracker(model: tracker)
//    }
//    
//    private func createButtonPressedIsEnabled() {
//        if dataProvider.updateButtonEnabled() {
//            saveButton.isEnabled = true
//            saveButton.backgroundColor = .ypWhite
//        } else {
//            saveButton.isEnabled = false
//            saveButton.backgroundColor = .ypGray
//        }
//    }
//    
//    private func scheduleButtonPressed() {
//        let scheduleVC = ScheduleViewController()
////        scheduleVC.delegate = self
//        present(scheduleVC, animated: true)
//    }
//    
//    
//    private func categoryButtonPressed() {
//        let categoryVC = CategoryViewController()
//        present(categoryVC, animated: true)
//    }
//    
//    private func setupLayout() {
//        NSLayoutConstraint.activate([
//            
//            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
//            
//            counterHeader.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
//            counterHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            scrollView.topAnchor.constraint(equalTo: counterHeader.bottomAnchor, constant: 38),
//            scrollView.bottomAnchor.constraint(equalTo: bottomButtonsStack.topAnchor, constant: -16),
//            
//            trackerHeaderTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
//            trackerHeaderTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
//            trackerHeaderTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
//            trackerHeaderTextField.heightAnchor.constraint(equalToConstant: 75),
//            
//            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
//            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
//            tableView.topAnchor.constraint(equalTo: trackerHeaderTextField.bottomAnchor, constant: 38),
//            tableView.heightAnchor.constraint(equalToConstant: CGFloat(arrayOfButtons.count * 75)),
//            
//            emojiesCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
//            emojiesCollectionViewHeaderLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
//            
//            emojiesCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
//            emojiesCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
//            emojiesCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            emojiesCollectionView.topAnchor.constraint(equalTo: emojiesCollectionViewHeaderLabel.bottomAnchor, constant: 5),
//            emojiesCollectionView.heightAnchor.constraint(equalToConstant: 220),
//            
//            colorsCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: emojiesCollectionViewHeaderLabel.leadingAnchor),
//            colorsCollectionViewHeaderLabel.topAnchor.constraint(equalTo: emojiesCollectionView.bottomAnchor, constant: 16),
//            
//            colorsCollectionView.leadingAnchor.constraint(equalTo: emojiesCollectionView.leadingAnchor),
//            colorsCollectionView.trailingAnchor.constraint(equalTo: emojiesCollectionView.trailingAnchor),
//            colorsCollectionView.topAnchor.constraint(equalTo: colorsCollectionViewHeaderLabel.bottomAnchor, constant: 5),
//            colorsCollectionView.heightAnchor.constraint(equalTo: emojiesCollectionView.heightAnchor),
//            colorsCollectionView.widthAnchor.constraint(equalTo: emojiesCollectionView.widthAnchor),
//            colorsCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
//            
//            bottomButtonsStack.leadingAnchor.constraint(equalTo: trackerHeaderTextField.leadingAnchor),
//            bottomButtonsStack.trailingAnchor.constraint(equalTo: trackerHeaderTextField.trailingAnchor),
//            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
//            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
//        ])
//    }
//}
//
////MARK: - UITableViewDelegate
//
//extension EditTrackerViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrayOfButtons.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? CreateNewTrackerTableVIewCell else { return UITableViewCell() }
//        cell.label.text = dataProvider.tableViewTitle[indexPath.row]
//        
//        switch indexPath.row {
//        case 0:
//            if let selectedCategory = dataProvider.selectedCategory {
//                cell.label.removeConstraints(cell.label.constraints)
//                cell.configureCellWithCategory(selectedCategory)
//            } else {
//                cell.configureCellWithoutCategory()
//            }
//        case 1:
//            if let selectedSchedule = dataProvider.selectedSchedule {
//                cell.label.removeConstraints(cell.label.constraints)
//                cell.configureCellWithCategory(selectedSchedule)
//            } else {
//                cell.configureCellWithoutCategory()
//            }
//        default:
//            cell.configureCellWithoutCategory()
//        }
////        checkCreateButton()
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 0 {
//            categoryButtonPressed()
//        } else if indexPath.row == 1 {
//            scheduleButtonPressed()
//        }
//    }
//}
//
//
////MARK: - CollectionViewDelegate
//
//extension EditTrackerViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return dataProvider.emojies.count
//        case 1:
//            return dataProvider.colors.count
//        default:
//            return 10
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CreateNewTrackerCollectionViewCell
//              
//        switch indexPath.section {
//        case 0:
//            cell.configureEmojiCell(emoji: dataProvider.emojies[indexPath.row])
//            return cell
//        case 1:
//            cell.configureColorCell(color: dataProvider.colors[indexPath.row])
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
//    }
//}
//
//extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (emojiesCollectionView.bounds.width - 14 ) / 6
//        let height = width
//        return CGSize(width: width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateNewTrackerCollectionViewCell else { return }
//        
//        switch indexPath.section {
//        case 0:
//            cell.layer.cornerRadius = 16
//            cell.backgroundColor = .ypLightGray
//            dataProvider.trackerEmoji = cell.emojiLabel.text
//        case 1:
//            cell.layer.cornerRadius = 11
//            cell.layer.borderColor = dataProvider.colors[indexPath.row].withAlphaComponent(0.3).cgColor
//            cell.layer.borderWidth = 3
//            dataProvider.trackerColor = dataProvider.colors[indexPath.row]
//        default:
//            cell.backgroundColor = .gray
//        }
////        checkCreateButton()
//    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//        if let selectedIndexPath = emojiesCollectionView.indexPathsForSelectedItems?.first {
//            emojiesCollectionView.deselectItem(at: selectedIndexPath, animated: false)
//        }
//    }
//}
//
////MARK: - UITextFieldDelegate
//
//extension EditTrackerViewController: UITextFieldDelegate {
//    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        guard let queryTextFiled = trackerHeaderTextField.text else { return }
//        DataProvider.shared.title = queryTextFiled
//        createButtonPressedIsEnabled()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        trackerHeaderTextField.resignFirstResponder()
//        return true
//    }
//    
//    @objc private func hideKeyboard() {
//        view.endEditing(true)
//    }
//    
//    private func setupKeyboard() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
//}
