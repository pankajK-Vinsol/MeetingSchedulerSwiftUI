//
//  SchedulerView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 01/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

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
                List {
                    VStack(alignment: .center) {
                        TextField("Meeting Date", text: $meetingDate)
                            .frame(height: 40)
                            .modifier(CustomTextField())
                            .disabled(true)
                            .padding(7)
                        
                        TextField("Start Time", text: $startTime, onEditingChanged: { editing in
                            self.showDatePicker = editing
                        }, onCommit: { })
                            .frame(height: 40)
                            .modifier(CustomTextField())
                            .padding(7)
                        
                        TextField("End Time", text: $endTime, onEditingChanged: { editing in
                            self.showDatePicker = editing
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
                            
                        }) {
                            Text("SUBMIT")
                                .frame(width: 200, height: 50, alignment: .center)
                                .modifier(ButtonTextStyle())
                                .modifier(BackgroundColorStyle())
                                .cornerRadius(8)
                        }
                        
                        if self.showDatePicker {
                            MyDatePicker(selection: $currentSelectedTime, minuteInterval: minterval, minimumTime: 9, maximumTime: 17)
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
        } else {
            return ZStack {
                List {
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
}

struct SchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView()
    }
}

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
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let today = Calendar.current.date(from: components)!
        picker.date = selection
        picker.minimumDate = today.addingTimeInterval(60 * 60 * minimumTime)
        picker.maximumDate = today.addingTimeInterval(60 * 60 * maximumTime)
        picker.datePickerMode = .time
    }

    class Coordinator {
        let datePicker: MyDatePicker
        init(_ datePicker: MyDatePicker) {
            self.datePicker = datePicker
        }
        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
        }
    }
}
