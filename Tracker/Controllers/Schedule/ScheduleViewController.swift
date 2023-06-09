//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 11.06.2023.
//

import UIKit


final class ScheduleViewController: UIViewController {
    
    
    static let shared = ScheduleViewController()
    var presenter: TrackerViewPresenterProtocol?
    var createTrackerViewController: CreateTrackerViewControllerProtocol?
    private let trackerStorage = TrackerStorageService.shared
    

    private let scheduleService = ScheduleService()
    var daysInInt: [Int] = []
    var days: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var scheduleTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.separatorStyle = .singleLine
        table.allowsSelection = false
        return table
    }()
    
    lazy var doneButton: UIButton = {
        let done = UIButton(type: .system)
        done.translatesAutoresizingMaskIntoConstraints = false
        done.setTitle("Готово", for: .normal)
        done.titleLabel?.textAlignment = .center
        done.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        done.backgroundColor = .ypBlack
        done.tintColor = .ypWhite
        done.layer.cornerRadius = 16
        return done
    }()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setupTableView()
        addTarget()
    }
    
    private func setupTableView() {
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    private func addTarget() {
        doneButton.addTarget(self, action: #selector(returnToNewTrackerVC), for: .touchUpInside)
    }
    
    @objc private func returnToNewTrackerVC() {
        let scheduleDay = daysInInt.count == 7 ? "Каждый день" : scheduleService.arrayToString(array: daysInInt)
        trackerStorage.selectedSchedule = scheduleDay
        trackerStorage.schedule = daysInInt
        createTrackerViewController?.reloadTableView()
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.configureCell(text: days[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//MARK: UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ScheduleViewController: ScheduleViewControllerDelegate {
    func addDaysToSchedule(cell: ScheduleTableViewCell) {
        guard let fullNameofDay = cell.label.text else { return }
        
        let shortNameOfDay = scheduleService.addDayToSchedule(day: fullNameofDay)
        if cell.switcher.isOn {
            daysInInt.append(shortNameOfDay)
        } else {
            if let index = daysInInt.firstIndex(of: shortNameOfDay) {
                daysInInt.remove(at: index)
            }
        }
    }
}

//MARK: SetupViews
extension ScheduleViewController {
    private func addView() {
        view.backgroundColor = .ypWhite
        view.addSubview(scheduleLabel)
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 520),
            
            scheduleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}


