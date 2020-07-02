//
//  SchedulerView.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 01/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import SwiftUI

struct SchedulerView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            //DatePicker(selection: $selectedDate, in: dateClosedRange, displayedComponents: .date, label: { Text("Due Date") })
            
            Button(action: {
                //DoneClick()
            }) {
                Text("DONE")
                    .frame(width: 42, height: 30, alignment: .center)
            }
            .aspectRatio(contentMode: .fill)
            .offset(x: 248, y: 0)
            
            Button(action: {
                //CancelClick()
            }) {
                Text("CANCEL")
                    .frame(width: 59, height: 30, alignment: .center)
            }
            .aspectRatio(contentMode: .fill)
        }
    }
}

struct SchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView()
    }
}
