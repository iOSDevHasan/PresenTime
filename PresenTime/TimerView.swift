//
//  TimerView.swift
//  PresenTime
//
//  Created by Hasan Berat Gürbüz on 10.01.2025.
//

import SwiftUI

struct TimerView: View {

    // MARK: PROPERTIES

    @EnvironmentObject private var viewModel: TimerVM
    @State private var width: CGFloat = 0
    @State private var isDurationButtonVisible: Bool = false
    @State private var showTimePicker = false
    @State private var showDurationTimePicker = false
    @State private var selectedColor: Color = .blue
    @State private var repeatTimeList: [Int] = [1,2,3,4,5]

    // MARK: - BODY

    var body: some View {
        VStack {
            Text("PresenTime")
                .font(.title3.bold())

            // MARK: - UTILS VIEW

            HStack {

                // MARK: - RepeatTime PickerView

                Menu {
                    ForEach(repeatTimeList, id: \.self) { item in
                        Button(action: {
                            viewModel.repeatTime = item
                        }) {
                            Text("Notification Repeats \(item) Time")
                                .lineLimit(1)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                        Text("\(viewModel.repeatTime)")
                        Image(systemName: "chevron.down")
                    }
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .font(.system(size: 15).bold())
                    .background(selectedColor)
                    .cornerRadius(10)
                }
                .padding(.leading, 10)

                // MARK: - Color PickerView

                ColorPicker("", selection: $selectedColor)
                    .padding(.trailing, 10)
            }

            // MARK: - TIMER VIEW

            ZStack {
                Circle()
                    .stroke(lineWidth: width / 10)
                    .foregroundStyle(selectedColor.opacity(0.4))
                Circle()
                    .trim(from: 0.0, to: min(1-viewModel.progress, 1.0))
                    .stroke(selectedColor.gradient, style: StrokeStyle(
                        lineWidth: width / 10,
                        lineCap: .round,
                        lineJoin: .miter))
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 2)
                Circle()
                    .foregroundStyle(.white)
                    .shadow(color: selectedColor.opacity(0.6), radius: 5)
                    .frame(width: width / 6)
                    .offset(x: -width / (viewModel.durationTime.isEmpty ? 2 : 2.1))
                    .rotationEffect(.degrees(90.0 - 360 * viewModel.progress))
                VStack {
                    Text(viewModel.length.displayTimeForTotalSeconds())
                        .monospacedDigit()
                        .font(.system(size: width / 12))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: width / 2)
                    
                    Text(viewModel.remainingTime.displayTimeForTotalSeconds())
                        .monospacedDigit()
                        .font(.system(size: width / 3))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: width / 1.2)
                }
                .foregroundStyle(selectedColor)
                .bold()
                .contentTransition(.numericText())
            }
            .readSize { size in
                width = size.width
            }
            .padding(width / 8)
            .animation(.linear, value: viewModel.remainingTime)

            // MARK: - ACTION BUTTON VIEW

            HStack {
                Button {
                    viewModel.startTimer()
                } label: {
                    Image(systemName: "play.fill")
                }
                .modifier(ControlButtonStyle(color: selectedColor, disabled: viewModel.playButtonDisabled))
                Button {
                    viewModel.stopTimer()
                } label: {
                    Image(systemName: "pause.fill")
                }
                .modifier(ControlButtonStyle(color: selectedColor, disabled: viewModel.pauseButtonDisabled))
                Button {
                    viewModel.resetTimer()
                } label: {
                    Image(systemName: "gobackward")
                }
                .modifier(ControlButtonStyle(color: selectedColor, disabled: viewModel.resetButtonDisabled))
            }

            // MARK: - SET&ADD BUTTON VIEW

            HStack(spacing: 50) {
                Button {
                    showTimePicker = true
                } label: {
                    Text("Set Time")
                        .foregroundStyle(.white)
                        .font(.system(size: 15).bold())
                        .padding(.all, 10)
                        .background(Rectangle().fill(selectedColor))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showTimePicker) {
                    PickerView(maxSeconds: nil, pickerName: "Set Time!", pickerColor: selectedColor) { selectedTime in
                        viewModel.length = selectedTime
                        if viewModel.length > 0 {
                            viewModel.durationTime.removeAll()
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
                        .background(Rectangle().fill(isDurationButtonVisible ? selectedColor : selectedColor.opacity(0.4)))
                        .cornerRadius(10)
                }
                .disabled(!isDurationButtonVisible)
                .sheet(isPresented: $showDurationTimePicker) {
                    PickerView(maxSeconds: viewModel.length, pickerName: "Add Duration!", pickerColor: selectedColor) { selectedTime in
                        if selectedTime != viewModel.length, !viewModel.durationTime.contains(where: { $0 == selectedTime }), selectedTime != 0 {
                            viewModel.durationTime.append(selectedTime)
                        }
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
            }
            .padding()

            // MARK: - LIST VIEW

            if !viewModel.durationTime.isEmpty {
                VStack(alignment: .leading) {
                    Text("DURATIONS")
                        .foregroundStyle(.primary)
                        .font(.title2.bold())
                        .padding(.leading, 30)
                    List {
                        ForEach(viewModel.durationTime, id: \.self) { duration in
                            HStack(spacing: 20) {
                                Image(systemName: "clock")
                                Text(duration.displayTimeForTotalSeconds())
                            }
                            .font(.system(size: 20).bold())
                            .foregroundStyle(.white)
                            .listRowBackground(selectedColor)
                        }
                        .onDelete { item in
                            viewModel.durationTime.remove(atOffsets: item)
                        }
                        .onMove { index, item in
                            viewModel.durationTime.move(fromOffsets: index, toOffset: item)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                }
                .padding()
            }
            Spacer()
        }
    }
}

// MARK: - ControlButtonStyle ViewModifier

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
