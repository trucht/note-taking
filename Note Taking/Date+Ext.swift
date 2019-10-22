//
//  Date_Ext.swift
//  Note Taking
//
//  Created by Truc on 10/18/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation

extension Date {
    func toSecond() -> Int64 {
        return Int64(self.timeIntervalSince1970.rounded())
    }
    
    init(seconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(Double(seconds)))
    }
}
