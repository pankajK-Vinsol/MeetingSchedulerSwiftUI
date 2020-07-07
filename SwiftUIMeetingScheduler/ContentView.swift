//
//  ContentView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 01/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

var meetArr : [MeetingData] = []

struct ContentView: View {
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.12941177, green: 0.5686275, blue: 0.44705883, alpha: 1.0)
    }
    
    @State private var dateString = ""
    @State private var date = NSDate()
    @State private var disableScheduleButton = false
    @State private var meetingArray = [MeetingData]()
    @State private var shouldCallAPI = true
    @State private var showingChildView = false
    
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
            List(meetingArray) { item in
                MeetingRow(meet: item)
            }
            .onAppear {
                UITableView.appearance().separatorStyle = .none
                self.canScheduleMeetingForDate(self.date)
                self.callAPI()
            }
            .onDisappear {
                self.shouldCallAPI = false
            }
            NavigationLink(destination: SchedulerView()) {
                Text("SCHEDULE COMPANY MEETING").modifier(ButtonTextStyle())
                    .frame(width: 280, height: 40, alignment: .center)
            }
            .disabled(disableScheduleButton)
            .modifier(BackgroundColorStyle())
            .cornerRadius(8)
            
            NavigationLink(destination: ConfigView(), isActive: self.$showingChildView) {
                Text("")
            }
        }
        .onAppear(perform: setInitialNavigationTitle)
        .navigationBarTitle(Text(dateString), displayMode: .inline)
        .navigationBarItems(leading:
            Button(action: {
            self.showPreviousDate()})
            {
            Text("PREV").modifier(ButtonTextStyle())
            },
            trailing:
            HStack {
            Button(action: {
                self.showNextDate()
            }) {
                Text("NEXT").modifier(ButtonTextStyle())
        }
            Button(action: {
                self.showingChildView = true
                }) {
                    Text("CONFIG").modifier(ButtonTextStyle())
            }
        })
    }
    
    private func callAPI() {
        if shouldCallAPI {
            let serverUrl = "http://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(dateString)"
            API.getMeetingData(serverUrl) {
                (meetingArr) in
                DispatchQueue.main.async {
                    if let arr = meetingArr, arr.count > 0 {
                        self.meetingArray = arr
                        meetArr = arr
                        UserDefaults.standard.set(self.dateString, forKey: "meetingDate")
                    }
                }
            }
        } else {
            return
        }
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
        shouldCallAPI = true
        callAPI()
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
        shouldCallAPI = true
        callAPI()
    }
    
    private func convertDateAsString(dateString: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: dateString as Date)
    }
    
    private func canScheduleMeetingForDate(_ getDate: NSDate) {
        let checkDate = NSDate()
        let checkDateString = convertDateAsString(dateString:  NSDate())
        if dateString == checkDateString {
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            let time = format.string(from: checkDate as Date).replacingOccurrences(of: ":", with: "")
            guard let timeInt = Int(time) else { return }
            if timeInt > 1600 {
                disableScheduleButton = true
            } else {
                disableScheduleButton = false
            }
        }
        else if getDate.compare(checkDate as Date) == .orderedDescending {
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
    var meet: MeetingData
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            return ZStack {
                VStack(alignment: .leading) {
                    Text(verbatim: "\(self.meet.start_Time ?? "") - \(self.meet.end_Time ?? "")")
                    Text(verbatim: self.meet.meeting_Disc ?? "")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.cornerRadius(5).shadow(radius: 3))
            }.erase()
        } else {
            return ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(verbatim: "\(self.meet.start_Time ?? "")")
                        Text("------")
                        Text(verbatim: "\(self.meet.end_Time ?? "")")
                    }
                    Text(verbatim: self.meet.meeting_Disc ?? "")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.cornerRadius(5).shadow(radius: 3))
            }.erase()
        }
    }
}

struct MeetingRow_Previews: PreviewProvider {
    static var previews: some View {
        MeetingRow(meet: meetArr[0])
    }
}

extension  View {
    func erase() -> AnyView {
        return AnyView(self)
    }
}
