//
//  SchedulerView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 01/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

var timeType = 1

struct MyDatePicker: UIViewRepresentable {
    @Binding var selection: Date
    let minuteInterval: Int
    let minimumTime: Double
    let maximumTime: Double

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MyDatePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }

    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyDatePicker>) {
        picker.minuteInterval = minuteInterval
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .month, .year], from: now)
        let today = Calendar.current.date(from: components)!
        let hour = Calendar.current.component(.hour, from: now)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let nowDateString = dateFormatter.string(from: now as Date)
        let meetingSelectDate = UserDefaults.standard.value(forKey: "meetingDate") as? String ?? ""
        var currentSetTime = Double()
        if nowDateString == meetingSelectDate {
            currentSetTime = max(minimumTime, Double(hour + 1))
        } else {
            currentSetTime = minimumTime
        }
        picker.minimumDate = today.addingTimeInterval(60 * 60 * currentSetTime)
        picker.maximumDate = today.addingTimeInterval(60 * 60 * maximumTime)
        picker.date = selection
        picker.datePickerMode = .time
    }

    class Coordinator {
        let datePicker: MyDatePicker
        init(_ datePicker: MyDatePicker) {
            self.datePicker = datePicker
        }
        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
            let format = DateFormatter()
            format.dateFormat = "hh:mm a"
            let selectedValue = format.string(from: sender.date)
            let format24Hour = DateFormatter()
            format24Hour.dateFormat = "HH:mm"
            let startTime24 = format24Hour.string(from: sender.date)
            if timeType == 1 {
                UserDefaults.standard.set(selectedValue, forKey: "startTime")
                UserDefaults.standard.set(startTime24, forKey: "24StartTime")
            } else {
                UserDefaults.standard.set(selectedValue, forKey: "endTime")
            }
        }
    }
}

struct SchedulerView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var meetingDate = "\(String(describing: UserDefaults.standard.value(forKey: "meetingDate") as? String ?? ""))"
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var description = ""
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var showDatePicker = false
    @State var currentSelectedTime = Date()
    @State var minterval: Int = 30
    
    @State var showsAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var dismissScheduleView = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
    
    struct CustomTextField: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 4)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
    }
    
    var body: some View {
        if horizontalSizeClass == .compact {
            return ZStack {
                Form {
                    VStack(alignment: .center) {
                        TextField("Meeting Date", text: $meetingDate)
                            .frame(height: 40)
                            .modifier(CustomTextField())
                            .disabled(true)
                            .padding(7)
                        
                        TextField("Start Time", text: $startTime, onEditingChanged: { editing in
                            self.showDatePicker = editing
                            timeType = 1
                        }, onCommit: { })
                            .frame(height: 40)
                            .modifier(CustomTextField())
                            .padding(7)
                        
                        TextField("End Time", text: $endTime, onEditingChanged: { editing in
                            self.showDatePicker = editing
                            timeType = 2
                        }, onCommit: { })
                            .frame(height: 40)
                            .modifier(CustomTextField())
                            .padding(7)
                        
                        TextField("Description", text: $description)
                            .frame(height: 120)
                            .modifier(CustomTextField())
                            .lineLimit(nil)
                            .padding(7)
                        
                        Button(action: {
                            self.submitForMeeting()
                        }) {
                            Text("SUBMIT")
                                .frame(width: 200, height: 50, alignment: .center)
                                .modifier(ButtonTextStyle())
                                .modifier(BackgroundColorStyle())
                                .cornerRadius(8)
                        }
                        .alert(isPresented: $showsAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage),
                                dismissButton: .default (Text("OK")) {
                                    if self.dismissScheduleView {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                })
                        }
                    }
                    .padding()
                    .navigationBarTitle(Text("SCHEDULE A MEETING"), displayMode: .inline)
                    
                    Section {
                        if self.showDatePicker {
                            Button(action: {
                                self.showDatePicker = false
                                self.setTime(type: timeType)
                            }) {
                                Text("DONE")
                                .frame(alignment: .center)
                            }
                            MyDatePicker(selection: $currentSelectedTime, minuteInterval: minterval, minimumTime: lastStartTime, maximumTime: lastEndTime)
                        }
                    }
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableViewCell.appearance().selectionStyle = .none
                }
            }.erase()
        } else {
            return ZStack {
                Form {
                    VStack(alignment: .leading) {
                        TextField("Meeting Date", text: $meetingDate)
                        .frame(height: 40)
                        .modifier(CustomTextField())
                        .disabled(true)
                        .padding(7)
                        
                        HStack {
                            TextField("Start Time", text: $startTime, onEditingChanged: {_ in
                                
                            }, onCommit: {
                                
                            })
                                .frame(height: 40)
                                .modifier(CustomTextField())
                                .padding(7)
                            
                            TextField("End Time", text: $endTime, onEditingChanged: {_ in
                                
                            }, onCommit: {
                                
                            })
                                .frame(height: 40)
                                .modifier(CustomTextField())
                                .padding(7)
                        }
                        
                        TextField("Description", text: $description)
                        .frame(height: 80)
                        .modifier(CustomTextField())
                        .lineLimit(nil)
                        .padding(7)
                        
                        Button(action: {
                            
                        }) {
                            Text("SUBMIT")
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                                .modifier(ButtonTextStyle())
                                .modifier(BackgroundColorStyle())
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .navigationBarTitle(Text("SCHEDULE A MEETING"), displayMode: .inline)
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableViewCell.appearance().selectionStyle = .none
                }
            }.erase()
        }
    }
    
    private func setTime(type: Int) {
        if type == 1 {
            self.startTime = UserDefaults.standard.value(forKey: "startTime") as? String ?? ""
        } else {
            self.endTime = UserDefaults.standard.value(forKey: "endTime") as? String ?? ""
        }
    }
    
    private func submitForMeeting() {
        let defaults: UserDefaults = UserDefaults.standard
        let startMeetingsArr = defaults.value(forKey: "TimeBookedStart") as? NSArray ?? NSArray()
        let startTime24 = Int(defaults.value(forKey: "24StartTime") as? String ?? "")
        
        for i in 0 ..< startMeetingsArr.count{
            if startTime24 == startMeetingsArr[i] as? Int ?? 0 {
                alertTitle = "Slot already booked"
                alertMessage = "Please choose another slot."
                showsAlert = true
            }
        }
        
        // meeting scheduled on selected time by user.
        alertTitle = "Meeting Scheduled"
        alertMessage = "Slot is available."
        showsAlert = true
        dismissScheduleView = true
    }
}

struct SchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView()
    }
}
