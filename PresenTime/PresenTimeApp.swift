//
//  PresenTimeApp.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

@main
struct PresenTimeApp: App {
    @StateObject var timerVM = TimerVM()
    @Environment(\.scenePhase) private var phase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerVM)
                .onChange(of: phase) { _, newPhase in
                    switch newPhase {
                    case .background:
                        timerVM.lastActiveTimeStamp = Date()
                        UserDefaults.standard.set(timerVM.lastActiveTimeStamp?.timeIntervalSince1970, forKey: "lastActiveTimeStamp")
                    case .active:
                        timerVM.updateTimer()
                    default:
                        break
                    }
                }
        }
    }
}
