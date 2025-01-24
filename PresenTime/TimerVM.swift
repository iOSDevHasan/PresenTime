//
//  TimerVM.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 19.01.2025.
//

import SwiftUI

@Observable
class TimerVM {

    var length: Int = 0
    var timer: Timer? = nil
    var timeElapsed = 0
    var isTimerRunning = false
    var durationTime: [Int] = []
    
    var remainingTime: Int {
        length - timeElapsed
    }
    
    var progress: CGFloat {
        CGFloat(length - remainingTime) / CGFloat(length)
    }

    func startTimer() {
        isTimerRunning = true
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
}
