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
    
    @State private var meetingDate = ""
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var description = ""
    
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
        List {
            VStack(alignment: .center) {
                TextField("Meeting Date", text: $meetingDate)
                    .frame(height: 40)
                    .modifier(CustomTextField())
                    .disabled(true)
                
                TextField("Start Time", text: $startTime, onEditingChanged: {_ in
                    
                }, onCommit: {
                    
                })
                    .frame(height: 40)
                    .modifier(CustomTextField())
                
                TextField("End Time", text: $endTime, onEditingChanged: {_ in
                    
                }, onCommit: {
                    
                })
                    .frame(height: 40)
                    .modifier(CustomTextField())
                
                TextField("Description", text: $description)
                    .frame(height: 80)
                    .modifier(CustomTextField())
                    .lineLimit(nil)
                
                Button(action: {
                    
                }) {
                    Text("SUBMIT")
                        .frame(width: 200, height: 40, alignment: .center)
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
    }
}

struct SchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView()
    }
}
