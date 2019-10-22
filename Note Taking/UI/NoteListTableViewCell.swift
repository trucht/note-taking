//
//  NoteListTableViewCell.swift
//  Note Taking
//
//  Created by Truc on 10/18/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNoteTitle: UILabel!
    @IBOutlet weak var lblNoteContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
