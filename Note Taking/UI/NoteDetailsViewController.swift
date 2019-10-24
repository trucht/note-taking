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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var note: NoteObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    private func setupUI() {
        guard let note = note else {return}
        activityIndicator.startAnimating()
        lblNoteTitle.text = note.title
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = true
        webView.contentMode = .scaleToFill
        webView.scalesLargeContentImage = true
    }
    
    private func loadWebView() {
        guard let note = note else {return}
        let contentHTML = """
        <html>
        <body>
        \(note.content)
        </body>
        </html>
        """
        var htmlString = "<header><meta name='viewport' content='width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
        htmlString.append(contentHTML)
        webView.loadHTMLString(htmlString.HTMLImageCorrector(), baseURL: nil)
    }
}

extension NoteDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        let jsString = """
            document.getElementsByTagName('img')[0].style.width = "-webkit-fill-available"
            """
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }
}

extension NoteDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        nil
    }
}


