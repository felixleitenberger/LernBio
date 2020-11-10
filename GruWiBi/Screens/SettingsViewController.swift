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
    
    @IBOutlet var buy: UITableViewCell!
    @IBOutlet var restore: UITableViewCell!
    @IBOutlet var website: UITableViewCell!
    @IBOutlet var privacy: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTableView))
        title = "Einstellungen"
        
        tableView.tableFooterView = UIView()
        configureBuyCell()
        configureRestoreCell()
        configureWebsiteCell()
        configurePrivacyCell()
    }

    
    func configureBuyCell() {
        buy.textLabel?.text = "Alle AnimalCards verfügbar machen"
        buy.detailTextLabel?.text = "In der kostenlosen Version können 3 Animal Cards freigespielt werden. Belohne dein Lernen und aktiviere die übrigen liebevoll gestalteten 47 Animal Cards für nur 2,29€."
    }
    
    func configureRestoreCell() {
        restore.textLabel?.text = "Früheren Einkauf wiederherstellen"
        restore.detailTextLabel?.text = "Wenn du die Animal Cards schon einmal gekauft hast, kannst du sie hier wiederherstellen. Es wird nur der Kauf wiederhergestellt, nicht der Spielstand."
    }
    
    func configureWebsiteCell() {
        website.textLabel?.text = "Crabucate Website"
    }
    
    func configurePrivacyCell() {
        privacy.textLabel?.text = "Datenschutzerklärung"
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            switch StoreManager.shared.isAnimalPackUnlocked {
            case false:
                StoreManager.shared.showParentalAlert(on: self) { (_) in
                    self.buyInSettings()
                }
            case true:
                let alert = GWBAlertVC(title: "Alles in Ordnung", message: "Du kannst bereits alle AnimalCards freispielen. Falls es Probleme gibt, schreib an support@crabucate.de", buttonTitle: "Ok", animalCardImage: nil)
                self.present(alert, animated: true)
            }

        } else if indexPath.row == 1 {
            switch StoreManager.shared.isAnimalPackUnlocked {
            case false:
                StoreManager.shared.restorePurchases { (result) in
                    switch result {
                    case .success(_):
                        let alert = GWBAlertVC(title: "Kauf wiederhergestellt.", message: "Viel Spaß beim Lernen!", buttonTitle: "Ok", animalCardImage: nil)
                        self.present(alert, animated: true)
                    case.failure(_):
                        let alert = GWBAlertVC(title: "Kauf konnte nicht wiederhergestellt werden.", message: "Falls es Probleme gibt, schreib an support@crabucate.de", buttonTitle: "Ok", animalCardImage: nil)
                        self.present(alert, animated: true)
                    }
                }
            case true:
                let alert = GWBAlertVC(title: "Alles in Ordnung", message: "Du kannst bereits alle AnimalCards freispielen. Falls es Probleme gibt, schreib an support@crabucate.de", buttonTitle: "Ok", animalCardImage: nil)
                self.present(alert, animated: true)
            }
        } else if indexPath.row == 2 {
            webView = WKWebView()
            webView.navigationDelegate = self
            let vc = UIViewController()
            vc.view = webView
            navigationController?.pushViewController(vc, animated: true)
            let url = URL(string: "https://www.crabucate.de")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        } else if indexPath.row == 3 {
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
    
    
    func buyInSettings() {
        if let product = StoreManager.shared.products?.first {
        StoreManager.shared.buy(product: product) { (result) in
            switch result {
            case .success(_):
                print("Yess")
            case .failure(let error):
                let ac = UIAlertController(title: "Kauf fehlgeschlagen", message: "Leider war der Kauf nicht erfolgreich. Fehler: \(error)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.dismiss(animated: true)
                }))
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    }
}

