//
//  ViewController.swift
//  Note Taking
//
//  Created by Truc on 10/11/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import UIKit
import WebKit

class EditNoteViewController: UIViewController {
        
    //Edit Existed Note
    class func initWith(note: NoteObject) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditNoteViewController") as! EditNoteViewController
        vc.note = note
        return vc
    }
    
    //Create New Note
    class func initWithStoryboard() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditNoteViewController") as! EditNoteViewController
        return vc
    }
    
    //MARK: - Outlets
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var txtNoteTitle: UITextField!
    
    
    //MARK: - Properties
    let userContentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    var note: NoteObject?
    var noteContent: String = ""
    var noteTimestamp: Int64 = Date().toSecond()
    
    var didTapBtnDone: (()->())?
    
    
    //MARK: - Actions
    @IBAction func btnDoneTapped(_ sender: UIBarButtonItem) {
        handleBtnDoneTapped()
        if let didTapBtnDone = didTapBtnDone {
            didTapBtnDone()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelTapped(_ sender: UIBarButtonItem) {
        popToPreviousVC()
    }
    
    
    //MARK: - VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        setupWebView()
        setupNoteTitle()
        
    }
    
    //MARK: - Methods
    private func setupNoteTitle() {
        guard let note = note else {return}
        self.txtNoteTitle.text = note.title
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = .scaleToFill
    }
    
    private func createNote() {
        guard let title = txtNoteTitle.text else {return}
        let newNote = NoteObject(title: title, content: noteContent, timeStamp: noteTimestamp)
        NoteTakingStorage.storage.addNote(with: newNote)
    }
    
    private func updateNote() {
        guard let note = self.note, let title = txtNoteTitle.text else {return}
        let updateNote = NoteObject(id: note.id, title: title, content: noteContent, timeStamp: noteTimestamp)
        NoteTakingStorage.storage.updateNote(with: updateNote)
    }
    
    private func loadWebView() {
        if let url = Bundle.main.url(forResource: "editNote", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }

    private func handleBtnDoneTapped() {
        let js = "window.editor.getData();"
        webView.evaluateJavaScript(js) { [weak self] (result, _) in
            guard let strongSelf = self, let result = result else {return}
            strongSelf.noteContent = result as! String
            if strongSelf.note == nil {
                strongSelf.createNote()
            } else {
                strongSelf.updateNote()
            }
            NotificationCenter.default.post(name: .didTapBtnDone, object: self)
        }
    }
    
    private func popToPreviousVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func loadNote(data: String) {
        let js = """
            createEditor('\(data)');;
        """
        webView.evaluateJavaScript(js) { (_, error) in
            if error != nil {
                print(error as Any)
            }
        }
    }
}

//MARK: - Navigation Delegate
extension EditNoteViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if note != nil {
            loadNote(data: note!.content)
        } else {
            loadNote(data: "")
        }
    }
}

//MARK: - Scroll View Delegate
extension EditNoteViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
