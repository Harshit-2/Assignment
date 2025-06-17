//
//  SettingsViewController.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let notificationSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Constants.Colors.primaryColor
        return switchControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadSettings()
    }
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
        // Setup notification switch
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchChanged), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadSettings() {
        // Load current notification setting
        notificationSwitch.isOn = NotificationManager.shared.isNotificationsEnabled()
    }
    
    @objc private func notificationSwitchChanged() {
        let isEnabled = notificationSwitch.isOn
        
        if isEnabled {
            // Request permission if enabling
            NotificationManager.shared.requestNotificationPermission { [weak self] granted in
                if granted {
                    NotificationManager.shared.setNotificationsEnabled(true)
                    self?.showAlert(title: "Success", message: "Notifications enabled successfully!")
                } else {
                    // Revert switch if permission denied
                    self?.notificationSwitch.isOn = false
                    self?.showAlert(title: "Permission Denied", message: "Please enable notifications in Settings app to receive delete notifications.")
                }
            }
        } else {
            // Disable notifications
            NotificationManager.shared.setNotificationsEnabled(false)
            showAlert(title: "Disabled", message: "Delete notifications have been disabled.")
        }
    }
    
    @objc private func testNotification() {
        // Create a test DataItem for notification testing
        let testItem = DataItem()
        testItem.id = "test-123"
        testItem.name = "Test Item"
        testItem.data = "This is a test notification"
        
        NotificationManager.shared.sendDeleteNotification(for: testItem)
        showAlert(title: "Test Sent", message: "Test notification sent! Check your notification center.")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Notifications" : "Testing"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Enable this to receive notifications when you delete items from the home screen."
        }
        return "Tap to send a test notification and verify it's working."
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Delete Notifications"
            cell.accessoryView = notificationSwitch
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.text = "Send Test Notification"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            testNotification()
        }
    }
}
