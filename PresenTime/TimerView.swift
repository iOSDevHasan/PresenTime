//
//  TimerView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

struct TimerView: View {

    let timerObject: TimerVM
    @State private var width: CGFloat = 0
    @State private var durationTime: [Int] = []
    @State private var totalTime: Int = 0
    @State private var isDurationButtonVisible: Bool = false
    @State private var showTimePicker = false
    @State private var selectedSeconds: Int = 0
    @State private var showDurationTimePicker = false


    var body: some View {
        VStack {
            // MARK: - Circle View
            ZStack {
                Circle()
                    .stroke(lineWidth: width / 10)
                    .foregroundStyle(timerObject.timerColor.opacity(0.4))
                Circle()
                    .trim(from: 0.0, to: min(1-timerObject.progress, 1.0))
                    .stroke(timerObject.timerColor.gradient, style: StrokeStyle(
                        lineWidth: width / 10,
                        lineCap: .round,
                        lineJoin: .miter))
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 2)
                Circle()
                    .stroke(lineWidth: width / 20)
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .shadow(color: timerObject.timerColor.opacity(0.6), radius: 5)
                    .frame(width: width / 8)
                    .offset(x: -width / 2)
                    .rotationEffect(.degrees(90.0 - 360 * timerObject.progress))
                VStack {
                    Text(displayTime(timerObject.length))
                        .monospacedDigit()
                        .font(.system(size: width / 12))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: width / 2)
                    
                    Text(displayTime(timerObject.remainingTime))
                        .monospacedDigit()
                        .font(.system(size: width / 3))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: width / 1.2)
                }
                .foregroundStyle(timerObject.timerColor)
                .bold()
                .contentTransition(.numericText())
            }
            .readSize { size in
                width = size.width
            }
            .padding(width / 8)
            .animation(.linear, value: timerObject.remainingTime)

            // MARK: - Action Buttons
            HStack {
                Button {
                    timerObject.startTimer()
                } label: {
                    Image(systemName: "play.fill")
                }
                .modifier(ControlButtonStyle(color: timerObject.timerColor, disabled: timerObject.playButtonDisabled))
                Button {
                    timerObject.stopTimer()
                } label: {
                    Image(systemName: "pause.fill")
                }
                .modifier(ControlButtonStyle(color: timerObject.timerColor, disabled: timerObject.pauseButtonDisabled))
                Button {
                    timerObject.resetTimer()
                } label: {
                    Image(systemName: "gobackward")
                }
                .modifier(ControlButtonStyle(color: timerObject.timerColor, disabled: timerObject.resetButtonDisabled))
            }

            // MARK: - Set&Duration Buttons
            HStack(spacing: 50) {
                Button {
                    showTimePicker = true
                } label: {
                    Text("Set Time")
                        .foregroundStyle(.white)
                        .font(.system(size: 15).bold())
                        .padding(.all, 10)
                        .background(Rectangle().fill(timerObject.timerColor))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showTimePicker) {
                    PickerView(maxSeconds: nil, pickerName: "Set a time!", pickerColor: timerObject.timerColor) { selectedTime in
                        timerObject.length = selectedTime
                        selectedSeconds = selectedTime
                        if selectedSeconds > 0 {
                            isDurationButtonVisible = true
                        }
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
                Button {
                    showDurationTimePicker = true
                } label: {
                    Text("Add Duration")
                        .foregroundStyle(.white)
                        .font(.system(size: 15).bold())
                        .padding(.all, 10)
                        .background(Rectangle().fill(isDurationButtonVisible ? timerObject.timerColor : timerObject.timerColor.opacity(0.4)))
                        .cornerRadius(10)
                }
                .disabled(!isDurationButtonVisible)
                .sheet(isPresented: $showDurationTimePicker) {
                    PickerView(maxSeconds: selectedSeconds, pickerName: "Add Duration!", pickerColor: timerObject.timerColor) { selectedTime in
                        if selectedTime != selectedSeconds, !durationTime.contains(where: { $0 == selectedTime }) {
                            durationTime.append(selectedTime)
                        }
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
            }
            .padding()

            // MARK: - Duration List View
            if !durationTime.isEmpty {
                VStack(alignment: .leading) {
                    Text("DURATIONS")
                        .foregroundStyle(.primary)
                        .font(.title2.bold())
                        .padding(.leading, 30)
                    List {
                        ForEach(durationTime, id: \.self) { duration in
                            HStack(spacing: 20) {
                                Image(systemName: "clock")
                                Text(displayTime(duration))
                            }
                            .font(.system(size: 20).bold())
                            .foregroundStyle(.white)
                            .listRowBackground(timerObject.timerColor)
                        }
                        .onDelete { item in
                            durationTime.remove(atOffsets: item)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .padding()
            }
        }
    }
    
    private func displayTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%01d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    ContentView()
}

struct ControlButtonStyle: ViewModifier {
    let color: Color
    let disabled: Bool
    func body(content: Content) -> some View {
        content
            .font(.title)
            .bold()
            .frame(width: 50, height: 50)
            .background(color).opacity(disabled ? 0.5 : 1)
            .foregroundStyle(.white)
            .clipShape(Circle())
            .disabled(disabled)
    }
}
