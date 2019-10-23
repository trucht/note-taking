//
//  NoteDetailsViewController.swift
//  Note Taking
//
//  Created by Truc on 10/16/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import UIKit
import WebKit

class NoteDetailsViewController: UIViewController {
    
    class func initWithStoryboard() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NoteDetailsViewController") as NoteDetailsViewController
        return vc
    }
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    @IBOutlet weak var lblNoteTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var note: NoteObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        loadWebView()
        setupWebView()
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        showEditNoteVC()
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        backToNoteListVC()
    }
    
    private func showEditNoteVC() {
        guard let note = note else {return}
        let editNoteVC = EditNoteViewController.initWith(note: note)
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
    
    private func backToNoteListVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTitle() {
        guard let note = note else {return}
        lblNoteTitle.text = note.title
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = .scaleToFill
    }
    
    private func loadWebView() {
        guard let note = note else {return}
        let htmlString = """
        <html>
        <body>
        \(note.content)
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

extension NoteDetailsViewController: UIScrollViewDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
         })
    }
}

extension NoteDetailsViewController: WKNavigationDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        nil
    }
}
