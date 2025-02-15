//
//  PickerView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 20.01.2025.
//

import SwiftUI

struct PickerView: View {

    // MARK: - PROPERTIES

    @Environment(\.dismiss) var dismiss
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    private var maxHours: Int = 24
    private var maxMinutes: Int = 59
    private let maxSeconds: Int?
    private let pickerName: String
    private let pickerColor: Color
    private let completion: (Int) -> Void
    private let now = Date()

    init(
        maxSeconds: Int?,
        pickerName: String,
        pickerColor: Color,
        completion: @escaping (Int) -> Void
    ) {
        self.maxSeconds = maxSeconds
        self.pickerName = pickerName
        self.pickerColor = pickerColor
        self.completion = completion
        if let maxSeconds {
            self.maxHours = maxSeconds / 3600
            self.maxMinutes = (maxSeconds % 3600) / 60
        }
    }

    // MARK: - BODY

    var body: some View {

        VStack(spacing: 20) {
            Text(pickerName)
                .font(.title.bold())
                .foregroundStyle(.primary)
            
            HStack(spacing: 0) {
                Picker("", selection: $selectedHours) {
                    ForEach(0...maxHours, id: \.self) { hour in
                        Text("\(hour)")
                            .tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                Text("Hour")
                    .font(.caption)
                
                Picker("", selection: $selectedMinutes) {
                    ForEach(0...(selectedHours == maxHours ? maxMinutes : 59), id: \.self) { minutes in
                        Text("\(minutes)")
                            .tag(minutes)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                Text("Minutes")
                    .font(.caption)

            }

            Button("Save") {
                calculateTotalSeconds()
            }
            .font(.system(size: 20).bold())
            .padding(.all, 10)
            .padding(.horizontal, 30)
            .background(Rectangle().fill(pickerColor))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    // MARK: - PRIVATE FUNCTIONS

    private func calculateTotalSeconds() {
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60)
        completion(totalSeconds)
        dismiss()
    }
}

// MARK: - PREVIEW

#Preview {
    ContentView()
}
