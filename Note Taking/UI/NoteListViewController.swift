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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NoteListViewController") as NoteListViewController
        return vc
    }

    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnAddTapped(_ sender: UIBarButtonItem) {
        showAddNoteVC()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManagedContext()
        setupTableView()
        setupNotificationCenter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupManagedContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        NoteTakingStorage.storage.setManagedContext(with: managedContext)
    }
    
    private func setupNotificationCenter() {
         NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.didTapBtnDone, object: nil)
    }
    
    @objc private func reloadTableView() {
        setupManagedContext()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
    }
    
    private func showAddNoteVC() {
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
        guard let note = NoteTakingStorage.storage.getNote(at: indexPath.row) else {return UITableViewCell()}
        cell.lblNoteTitle.text = note.title
        cell.lblNoteContent.attributedText = note.content.convertHtml()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = NoteTakingStorage.storage.getNote(at: indexPath.row) else {return}
        let noteDetailVC = EditNoteViewController.initWithStoryboard() as! EditNoteViewController
        noteDetailVC.note = note
        navigationController?.pushViewController(noteDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NoteTakingStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
