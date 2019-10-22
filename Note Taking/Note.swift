//
//  Note.swift
//  Note Taking
//
//  Created by Truc on 10/11/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation

class NoteObject {
    let id: UUID
    var title: String
    var content: String
    var timeStamp: Int64
    
    init(title: String, content: String, timeStamp: Int64) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.timeStamp = timeStamp
    }
    
    init(id: UUID, title: String, content: String, timeStamp: Int64) {
        self.id = id
        self.title = title
        self.content = content
        self.timeStamp = timeStamp
    }
}
