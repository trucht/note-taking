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
    class func initWith(note: Note, index: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditNoteViewController") as! EditNoteViewController
        vc.note = note
        vc.index = index
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - Properties
    let userContentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    var note: Note?
    var noteContent: String = ""
    var noteTimestamp: Int64 = Date().toSecond()
    let noteListManager = NoteListManager.shared
    var index: Int = 0
    
    
    //MARK: - Actions
    @IBAction func btnDoneTapped(_ sender: UIBarButtonItem) {
        handleBtnDoneTapped()
    }
    
    @IBAction func btnCancelTapped(_ sender: UIBarButtonItem) {
        popToPreviousVC()
    }
    
    
    //MARK: - VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        setupWebView()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadViewIfNeeded()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        activityIndicator.startAnimating()
        self.title = note != nil ? "Edit Note" : "Add Note"
        self.txtNoteTitle.text = note?.title
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRect.height
            self.bottomConstraint.constant = keyboardHeight + 8
            self.reloadInputViews()
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.bottomConstraint.constant = 8
        self.reloadInputViews()
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = .scaleToFill
    }
    
    private func createNote() {
        guard let title = txtNoteTitle.text else {return}
        let newNote = Note(title: title, content: noteContent, timeStamp: noteTimestamp)
        noteListManager.addItem(newNote: newNote)
    }
    
    private func updateNote() {
        guard let note = self.note, let title = txtNoteTitle.text else {return}
        let updateNote = Note(id: note.id, title: title, content: noteContent, timeStamp: noteTimestamp)
        noteListManager.updateItem(at: index, with: updateNote)
    }
    
    private func loadWebView() {
        DispatchQueue.main.async {
            if let url = Bundle.main.url(forResource: "editNote", withExtension: "html") {
                self.webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
        }
    }
    
    private func handleBtnDoneTapped() {
        let js = "window.editor.getData();"
        webView.evaluateJavaScript(js) { [weak self] (result, _) in
            guard let strongSelf = self, let result = result else {return}
            strongSelf.noteContent = result as! String
            if strongSelf.note == nil {
                strongSelf.createNote()
                strongSelf.navigationController?.popViewController(animated: true)
            } else {
                strongSelf.updateNote()
                let viewControllers: [UIViewController] = strongSelf.navigationController!.viewControllers as [UIViewController]
                strongSelf.navigationController!.popToViewController(viewControllers[0], animated: true)
            }
            NotificationCenter.default.post(name: .didTapBtnDone, object: self)
        }
    }
    
    private func popToPreviousVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func loadNote(data: String) {
        let js = """
        createEditor('\(data)');
        """
        webView.evaluateJavaScript(js) { [weak self] (_, error) in
            if error != nil {
                print(error as Any)
            }
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
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
