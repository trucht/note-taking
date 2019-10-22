//
//  Helper.swift
//  Note Taking
//
//  Created by Truc on 10/18/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation

class NoteTakingDateHelper {
    static func convertDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
