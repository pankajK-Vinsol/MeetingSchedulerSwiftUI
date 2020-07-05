//
//  API.swift
//  SwiftUIMeetingScheduler
//
//  Created by Pankaj kumar on 02/07/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import Foundation
import Alamofire

var meetingData: [MeetingData] = []

class API: NSObject {
    
    class func getMeetingData(_ url: String, completionHandler:@escaping ([MeetingData]?) -> Void) {
        
        Alamofire.request(url , method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                
                guard let json = response.result.value as? [[String: AnyObject]] else {
                    completionHandler(nil)
                    return
                }
                
                var meetingArray = [MeetingData]()
                for i in 0..<json.count {
                    let jsonDataObj = json[i]
                    let dataObj = MeetingData(meetingInfo: jsonDataObj as NSDictionary)
                    meetingArray.append(dataObj)
                }
                
                // Sort unordered data according to time
                if meetingArray.count > 0 {
                    meetingArray = meetingArray.sorted(by: {Int($0.start_Time!.replacingOccurrences(of: ":", with: ""))! < Int($1.start_Time!.replacingOccurrences(of: ":", with: ""))!})
                    meetingData = meetingArray
                }
                
                completionHandler(meetingArray)
                
            case .failure(_):
                completionHandler(nil)
                break
            }
        }
    }
}
