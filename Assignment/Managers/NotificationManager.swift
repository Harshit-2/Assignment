//
//  NotificationManager.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    private let notificationEnabledKey = "NotificationsEnabled"
    
    // Check if notifications are enabled in settings
    func isNotificationsEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: notificationEnabledKey)
    }
    
    // Enable/Disable notifications
    func setNotificationsEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: notificationEnabledKey)
        print("Notifications \(enabled ? "enabled" : "disabled")")
    }
    
    // Request notification permission
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error)")
                    completion(false)
                } else {
                    print("Notification permission granted: \(granted)")
                    completion(granted)
                }
            }
        }
    }
    
    // Check current authorization status
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isAuthorized = settings.authorizationStatus == .authorized
                completion(isAuthorized)
            }
        }
    }
    
    // Send delete notification
    func sendDeleteNotification(for item: DataItem) {
        // Check if user has enabled notifications in app settings
        guard isNotificationsEnabled() else {
            print("Notifications are disabled in app settings")
            return
        }
        
        // Check system permission
        checkNotificationPermission { [weak self] hasPermission in
            guard hasPermission else {
                print("No notification permission")
                return
            }
            
            self?.scheduleDeleteNotification(for: item)
        }
    }
    
    private func scheduleDeleteNotification(for item: DataItem) {
        let content = UNMutableNotificationContent()
        content.title = "Item Deleted"
        content.body = "Successfully deleted: \(item.name ?? "selected Item")"
        
        // Add item details if available
        if let itemData = item.data, !itemData.isEmpty {
            content.body += "\nDetails: \(itemData)"
        }
        
        content.sound = .default
        content.badge = 1
        
        // Create identifier with item ID or generate UUID
        let identifier = "delete_\(item.id ?? UUID().uuidString)_\(Date().timeIntervalSince1970)"
        
        // Trigger notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Delete notification scheduled successfully for item: \(item.name ?? "Unknown")")
            }
        }
    }
}
