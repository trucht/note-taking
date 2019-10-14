//
//  ViewController.swift
//  Note Taking
//
//  Created by Truc on 10/11/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import UIKit
import WebKit

enum EditState {
    case Create
    case Edit
}

class EditNoteViewController: UIViewController {
    
    
    //Edit Existed Note
    class func initWith(note: Note) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditNoteViewController") as! EditNoteViewController
        vc.state = .Edit
        vc.note = note
        return vc
    }
    
    //Create New Note
    class func initWithStoryboard() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditNoteViewController") as! EditNoteViewController
        vc.state = .Create
        return vc
    }
    
    //MARK: - Outlets
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var txtNoteTitle: UITextField!
    
    
    //MARK: - Properties
    let userContentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    var firstTimeInit = false
    var note: Note?
    var noteContent: String = ""
    var state: EditState = .Create
    
    
    //MARK: - Actions
    @IBAction func btnDoneTapped(_ sender: UIBarButtonItem) {
        btnDoneTapped()
    }
    
    //MARK: - VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        setupNoteTitle()
        setupWebView()
    }
    
    //MARK: - Methods
    private func setupNoteTitle() {
        guard state == .Edit, let note = note else {return}
        self.txtNoteTitle.text = note.title
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = .scaleToFill
    }
    
    private func createNote() {
        note = Note(title: txtNoteTitle.text!, content: noteContent)
        print(note?.content ?? "empty note")
    }
    
    private func updateNote() {
        guard let note = note else {return}
        note.updateNote(with: txtNoteTitle.text!, content: noteContent)
        print(note.content)
    }
    
    private func loadWebView() {
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }

    private func btnDoneTapped() {
        let js = "editor.getData()"
        webView.evaluateJavaScript(js) { [weak self] (result, error) in
            guard let strongSelf = self else {return}
            strongSelf.noteContent = result as! String
            switch strongSelf.state {
            case .Create:
                strongSelf.createNote()
            case .Edit:
                strongSelf.updateNote()
            }
        }
    }
    
    private func loadNote(data: String) {
        let js = """
        editor.setData("\(data)");
        """
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}

//MARK: - Navigation Delegate
extension EditNoteViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !firstTimeInit {
            firstTimeInit = false
            loadNote(data: "<b>test test test</b>")
        }
    }
}

//MARK: - Scroll View Delegate
extension EditNoteViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
