//
//  ContentView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 01/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.12941177, green: 0.5686275, blue: 0.44705883, alpha: 1.0)
    }
    
    @State private var dateString = ""
    @State private var date = NSDate()
    @State private var disableScheduleButton = false
    
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
        VStack {
            List {
                MeetingRow()
            }
            NavigationLink(destination: SchedulerView()) {
                Text("SCHEDULE COMPANY MEETING").modifier(ButtonTextStyle())
                    .frame(width: 280, height: 40, alignment: .center)
            }
            .disabled(disableScheduleButton)
            .modifier(BackgroundColorStyle())
        }
        .onAppear(perform: setInitialNavigationTitle)
        .navigationBarTitle(Text(dateString), displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            self.showPreviousDate()
        }) {
            Text("PREV").modifier(ButtonTextStyle())
        },
        trailing: Button(action: {
            self.showNextDate()
        }) {
            Text("NEXT").modifier(ButtonTextStyle())
        })
    }
    
    private func setInitialNavigationTitle() {
        let weekDay = Calendar.current.component(.weekday, from: date as Date)
        if weekDay == 7 {
            date = Calendar.current.date(byAdding: .day, value: 2, to: date as Date)! as NSDate
        } else if weekDay == 1 {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date as Date)! as NSDate
        }
        dateString = convertDateAsString(dateString: date)
    }
    
    private func showPreviousDate() {
        let weekDay = Calendar.current.component(.weekday, from: date as Date)
        if weekDay == 2 {
            date = Calendar.current.date(byAdding: .day, value: -3, to: date as Date)! as NSDate
        } else {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date as Date)! as NSDate
        }
        dateString = convertDateAsString(dateString: date)
        canScheduleMeetingForDate(date)
    }
    
    private func showNextDate() {
        let weekDay = Calendar.current.component(.weekday, from: date as Date)
        if weekDay == 6 {
            date = Calendar.current.date(byAdding: .day, value: 3, to: date as Date)! as NSDate
        } else {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date as Date)! as NSDate
        }
        dateString = convertDateAsString(dateString: date)
        canScheduleMeetingForDate(date)
    }
    
    private func convertDateAsString(dateString: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: dateString as Date)
    }
    
    private func canScheduleMeetingForDate(_ getDate: NSDate) {
        let checkDate = NSDate()
        let checkDateString = convertDateAsString(dateString:  NSDate())
        if getDate.compare(checkDate as Date) == .orderedDescending || dateString == checkDateString {
            disableScheduleButton = false
        } else {
            disableScheduleButton = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MeetingRow: View {
    var body: some View {
        Text("Please be ready.")
            .frame(height: 50)
    }
}

struct MeetingRow_Previews: PreviewProvider {
    static var previews: some View {
        MeetingRow()
    }
}
