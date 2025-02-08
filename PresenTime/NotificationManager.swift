//
//  NotificationManager.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 24.01.2025.
//

import UserNotifications
import SwiftUI

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - PROPERTIES

    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - METHODS

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
        notificationCenter.delegate = self
    }

    func removeAllPendingNotificationRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func scheduleNotifications(durationTime: [Int], length: Int, repeatTime: Int) {
        for duration in durationTime {
            scheduleRepeatedNotification(timeInterval: TimeInterval(duration), subtitle: "The timer has reached \(duration.displayTimeForTotalSeconds())!", sound: .default, repeatTime: repeatTime)
        }
        scheduleRepeatedNotification(timeInterval: TimeInterval(length), subtitle: "Time is up!", sound: .defaultCritical, repeatTime: repeatTime)
    }

    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }

    // MARK: - PRIVATE METHODS

    private func scheduleRepeatedNotification(timeInterval: TimeInterval, subtitle: String, sound: UNNotificationSound, repeatTime: Int) {
        for i in 0..<repeatTime {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval + Double(i), repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "PresenTime"
            content.subtitle = subtitle
            content.sound = sound
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            notificationCenter.add(request)
        }
    }
}
