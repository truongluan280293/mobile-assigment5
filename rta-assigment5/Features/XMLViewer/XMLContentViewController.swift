//
//  XMLContentViewController.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/23/23.
//

import UIKit
import WebKit
import PKHUD

class XMLContentViewController: UIViewController {
    
    var filePath: String = ""
    var fileName: String = ""
   
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
    }
    
    func loadContent() {
        guard FileManager.default.fileExists(atPath: filePath) else { return }
        let url = URL.init(filePath: filePath)
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
    
    func setupUI() {
        webView.frame = view.bounds
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        navigationItem.title = fileName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(tapOnClose))
    }
    
    @objc func tapOnClose() {
        self.dismiss(animated: true)
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension XMLContentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        HUD.show(.systemActivity)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide()
    }
}
