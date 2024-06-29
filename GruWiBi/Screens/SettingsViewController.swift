//
//  SettingsViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 04.11.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit
import WebKit

class SettingsViewController: UITableViewController, WKNavigationDelegate {
    
    var webView: WKWebView!

    @IBOutlet var website: UITableViewCell!
    @IBOutlet var privacy: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTableView))
        title = "Einstellungen"
        
        tableView.tableFooterView = UIView()
        configureWebsiteCell()
        configurePrivacyCell()
    }

    
    func configureWebsiteCell() {
        website.textLabel?.text = "Crabucate Website"
    }
    
    func configurePrivacyCell() {
        privacy.textLabel?.text = "Datenschutzerklärung"
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            webView = WKWebView()
            webView.navigationDelegate = self
            let vc = UIViewController()
            vc.view = webView
            navigationController?.pushViewController(vc, animated: true)
            let url = URL(string: "https://www.crabucate.de")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        } else if indexPath.row == 1 {
            webView = WKWebView()
            webView.navigationDelegate = self
            let vc = UIViewController()
            vc.view = webView
            navigationController?.pushViewController(vc, animated: true)
            let url = URL(string: "https://www.crabucate.de/datenschutz.htm")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        webView = nil
    }
    
    
    @objc func dismissTableView() {
        dismiss(animated: true, completion: nil)
    }
}

