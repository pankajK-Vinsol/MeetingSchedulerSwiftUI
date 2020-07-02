//
//  MeetingData.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 02/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import Foundation

class MeetingData: NSObject, Identifiable {
    
    var start_Time: String?
    var end_Time: String?
    var meeting_Disc: String?
    
    init(meetingInfo : NSDictionary) {
        self.start_Time = meetingInfo["start_time"] as? String ?? ""
        self.end_Time = meetingInfo["end_time"] as? String ?? ""
        self.meeting_Disc = meetingInfo["description"] as? String ?? ""
    }
}
