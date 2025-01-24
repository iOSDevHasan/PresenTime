//
//  ContentView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimerView(viewModel: TimerVM())
            .onAppear {
                NotificationManager.shared.requestPermission { _ in }
                // TODO: Eger izin vermezse izin almasi icin ayarlara yonlendiricez. Popup.
            }
    }
}

#Preview {
    ContentView()
}
