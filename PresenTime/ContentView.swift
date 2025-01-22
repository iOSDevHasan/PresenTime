//
//  ContentView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimerView(timerObject: TimerVM())
    }
}

#Preview {
    ContentView()
}
