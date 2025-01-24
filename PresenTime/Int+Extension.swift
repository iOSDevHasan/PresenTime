//
//  Int+Extension.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 24.01.2025.
//

extension Int {
    func displayTimeForTotalSeconds() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        
        if hours > 0 {
            return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%01d:%02d", minutes, seconds)
        }
    }
}
