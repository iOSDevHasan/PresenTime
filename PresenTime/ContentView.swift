//
//  ContentView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

struct ContentView: View {

    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: TimerVM

    // MARK: - BODY

    var body: some View {
        TimerView()
            .environmentObject(viewModel)
            .onAppear { NotificationManager.shared.requestPermission { _ in } }
    }
}

// MARK: - PREVIEW

#Preview {
    ContentView()
        .environmentObject(TimerVM())
}
