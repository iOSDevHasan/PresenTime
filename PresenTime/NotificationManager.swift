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

    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func scheduleNotifications(durationTime: [Int], length: Int) {
        let notificationCenter = UNUserNotificationCenter.current()
        for duration in durationTime {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(duration), repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "PresenTime"
            content.subtitle = "The timer has reached \(duration.displayTimeForTotalSeconds())!"
            content.sound = .default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            notificationCenter.add(request)
        }

        let finalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(length), repeats: false)
        let finalContent = UNMutableNotificationContent()
        finalContent.title = "PresenTime"
        finalContent.subtitle = "Time is up!"
        finalContent.sound = .defaultCritical

        let finalRequest = UNNotificationRequest(identifier: UUID().uuidString, content: finalContent, trigger: finalTrigger)
        notificationCenter.add(finalRequest)
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
