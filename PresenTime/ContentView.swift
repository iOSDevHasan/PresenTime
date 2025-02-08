//
//  ContentView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TimerVM

    var body: some View {
        TimerView()
            .environmentObject(viewModel)
            .onAppear {
                NotificationManager.shared.requestPermission { _ in }
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(TimerVM())
}
