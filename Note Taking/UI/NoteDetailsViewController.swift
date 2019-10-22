//
//  NoteDetailsViewController.swift
//  Note Taking
//
//  Created by Truc on 10/16/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {

    class func initWithStoryboard() -> UIViewController {
        let vc = UIStoryboard(name: "main", bundle: nil).instantiateViewController(identifier: "NoteDetailsViewController") as NoteDetailsViewController
        return vc
    }
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    @IBOutlet weak var lblNoteTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
