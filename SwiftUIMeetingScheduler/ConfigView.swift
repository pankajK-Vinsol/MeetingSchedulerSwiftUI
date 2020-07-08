//
//  ConfigView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 07/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

var lastStartTime: Double = 9
var lastEndTime: Double = 17
var weekendStart: String = "Saturday"

struct ConfigView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var weekendDay = ""
    @State private var showDatePicker = false
    @State private var selectedPicker = 0
    
    @State private var selectedStart = 0
    @State private var selectedEnd = 0
    @State private var selectedWeekend = 0
    
    var startTimes = [8,9,10,11,12]
    var endTimes = [16,17,18,19,20]
    var weekendStartsFrom = ["Saturday", "Sunday"]
    
    struct CustomTextField: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 4)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
    }
    
    struct ButtonTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold, design: .default))
        }
    }
    
    struct BackgroundColorStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .background(Color(red: 0.12941177, green: 0.5686275, blue: 0.44705883))
        }
    }
    
    var body: some View {
        ZStack {
            Form {
                VStack(alignment: .center) {
                    TextField("Select Office Start Time", text: $startTime, onEditingChanged: { editing in
                        self.showDatePicker = editing
                        self.selectedPicker = 1
                    }, onCommit: { })
                        .frame(height: 40)
                        .modifier(CustomTextField())
                        .padding(7)
                    
                    TextField("Select Office End Time", text: $endTime, onEditingChanged: { editing in
                        self.showDatePicker = editing
                        self.selectedPicker = 2
                    }, onCommit: { })
                        .frame(height: 40)
                        .modifier(CustomTextField())
                        .padding(7)
                    
                    TextField("Weekend Starts From", text: $weekendDay, onEditingChanged: { editing in
                        self.showDatePicker = editing
                        self.selectedPicker = 3
                    }, onCommit: { })
                        .frame(height: 40)
                        .modifier(CustomTextField())
                        .padding(7)
                    
                    Button(action: {
                        lastStartTime = Double(self.startTime)!
                        lastEndTime = Double(self.endTime)!
                        weekendStart = self.weekendDay
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("SUBMIT")
                            .frame(width: 200, height: 50, alignment: .center)
                            .modifier(ButtonTextStyle())
                            .modifier(BackgroundColorStyle())
                            .cornerRadius(8)
                    }
                }
                .navigationBarTitle(Text("CONFIGURATION"), displayMode: .inline)
                
                Section {
                    if showDatePicker {
                        if selectedPicker == 1 {
                            Picker(selection: $selectedStart, label: Text("")) {
                                ForEach(0 ..< startTimes.count) {
                                    Text("\(self.startTimes[$0])")
                                }
                            }
                            Button(action: {
                                self.setValues()
                            }) {
                                Text("DONE")
                            }
                        } else if selectedPicker == 2 {
                            Picker(selection: $selectedEnd, label: Text("")) {
                                ForEach(0 ..< endTimes.count) {
                                    Text("\(self.endTimes[$0])")
                                }
                            }
                            Button(action: {
                                self.setValues()
                            }) {
                                Text("DONE")
                            }
                        } else {
                            Picker(selection: $selectedWeekend, label: Text("")) {
                                ForEach(0 ..< weekendStartsFrom.count) {
                                    Text(self.weekendStartsFrom[$0])
                                }
                            }
                            Button(action: {
                                self.setValues()
                            }) {
                                Text("DONE")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setValues() {
        showDatePicker = false
        if selectedPicker == 1 {
            startTime = "\(startTimes[selectedStart])"
        } else if selectedPicker == 2 {
            endTime = "\(endTimes[selectedStart])"
        } else {
            weekendDay = weekendStartsFrom[selectedWeekend]
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
