//
//  NotificationManager.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 24.01.2025.
//

import UserNotifications
import SwiftUI

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
            DispatchQueue.main.async {
                if success {
                    completion(success)
                } else {
                    completion(false)
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }

    func sendNotification(title: String, subtitle: String, sound: UNNotificationSound) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }

    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}
