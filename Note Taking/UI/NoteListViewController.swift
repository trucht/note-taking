//
//  NoteListViewController.swift
//  Note Taking
//
//  Created by Truc on 10/16/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {
        
    class func initWithStoryboard() -> UIViewController {
        let vc = UIStoryboard(name: "main", bundle: nil).instantiateViewController(identifier: "NoteListViewController") as NoteListViewController
        return vc
    }

    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var noteDetailViewController: NoteDetailsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManagedContext()
        setupTableView()
        showNoteDetail()
        showAddNote()
    }
    
    private func setupManagedContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        NoteTakingStorage.storage.setManagedContext(with: managedContext)
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
    }
    
    private func showNoteDetail() {
        let vc = NoteDetailsViewController.initWithStoryboard() as! NoteDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAddNote() {
        let vc = EditNoteViewController.initWithStoryboard() as! EditNoteViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NoteTakingStorage.storage.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as! NoteListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NoteTakingStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
