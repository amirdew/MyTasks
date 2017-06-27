//
//  UtilityHelper.swift
//  MyTasks
//
//  Created by amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import UIKit

class UtilityHelper {
    
    
    class func getHumanDateString(date:Date) -> String{
     
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        return "\(dateFormatter.string(from: date)), \(timeFormatter.string(from: date))"
    }
    
    class func setUserName(_ name:String) {
        UserDefaults.standard.set(name, forKey: "UserName")
    }
    
    class func getUserName() -> String {
       return UserDefaults.standard.value(forKey: "UserName") as? String ?? ""
    }
}
