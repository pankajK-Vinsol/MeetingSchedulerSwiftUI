//
//  ContentView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 01/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
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
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                }) {
                    Text("PREV").modifier(ButtonTextStyle())
                        .frame(height: 80.0)
                }
                .padding(.leading, 10)
                Spacer()
                Spacer()
                Text("07-01-2020").modifier(ButtonTextStyle())
                Spacer()
                Spacer()
                Button(action: {
                }) {
                    Text("NEXT").modifier(ButtonTextStyle())
                }
                .padding(.trailing, 10)
            }
            .modifier(BackgroundColorStyle())
            
            VStack {
                List {
                    MeetingRow()
                }
                
                NavigationLink(destination: SchedulerView()) {
                    Text("SCHEDULE COMPANY MEETING").modifier(ButtonTextStyle())
                        .frame(width: 280, height: 40, alignment: .center)
                }
                .modifier(BackgroundColorStyle())
            }
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
