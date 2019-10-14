//
//  Note.swift
//  Note Taking
//
//  Created by Truc on 10/11/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation

class Note {
    let id: UUID
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
    }
}

extension Note {
    func updateNote(with title: String, content: String) {
        self.title = title
        self.content = content
    }
}

