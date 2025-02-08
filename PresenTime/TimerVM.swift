//
//  TimerVM.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 19.01.2025.
//

import SwiftUI

final class TimerVM: ObservableObject {

    @Published var length: Int = 0
    @Published var timer: Timer? = nil
    @Published var timeElapsed = 0
    @Published var isTimerRunning = false
    @Published var durationTime: [Int] = []

    var lastActiveTimeStamp: Date?
    
    var remainingTime: Int {
        length - timeElapsed
    }
    
    var progress: CGFloat {
        CGFloat(length - remainingTime) / CGFloat(length)
    }

    var playButtonDisabled: Bool {
        guard remainingTime > 0, !isTimerRunning else { return true}
        return false
    }
    
    var pauseButtonDisabled: Bool {
        guard remainingTime > 0, isTimerRunning else { return true }
        return false
    }
    
    var resetButtonDisabled: Bool {
        guard remainingTime != length, !isTimerRunning else { return true }
        return false
    }

    func startTimer() {
        isTimerRunning = true
        lastActiveTimeStamp = Date()
        UserDefaults.standard.set(lastActiveTimeStamp?.timeIntervalSince1970, forKey: "lastActiveTimeStamp")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if remainingTime > 0 {
                timeElapsed += 1
                if durationTime.contains(timeElapsed) {
                    NotificationManager.shared.sendNotification(title: "PresenTime", subtitle: "The timer has reached \(timeElapsed.displayTimeForTotalSeconds())!", sound: .defaultRingtone)
                }
            } else {
                NotificationManager.shared.sendNotification(title: "PresenTime", subtitle: "Time is up", sound: .defaultCritical)
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        if isTimerRunning {
            isTimerRunning = false
            timer?.invalidate()
        }
    }
    
    func resetTimer() {
        timeElapsed = 0
        isTimerRunning = false
    }

    func updateTimer() {
        if let lastSavedTime = UserDefaults.standard.value(forKey: "lastActiveTimeStamp") as? TimeInterval {
            let elapsedTime = Int(Date().timeIntervalSince1970 - lastSavedTime)
            if elapsedTime > 0 {
                timeElapsed = min(timeElapsed + elapsedTime, length)
            }
        }
    }
}
