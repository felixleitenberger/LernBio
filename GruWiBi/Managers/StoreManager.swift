//
//  StoreManager.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 05.10.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import StoreKit

typealias FetchCompletionHandler = (Result<[SKProduct], GWBError>) -> Void
typealias PurchaseCompletionHandler = (Result<Bool, Error>) -> Void

class StoreManager: NSObject {
    static let shared = StoreManager()
    
    private override init() {
        super.init()
        print("State of AnimalPack: \(isAnimalPackUnlocked)")
    }
    
    var products: [SKProduct]!
    
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    var isAnimalPackUnlocked: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: "isAnimalPackUnlocked")
        }
        set(newValue) {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: "isAnimalPackUnlocked")
        }
    }
}


extension StoreManager {
    static let buyAllAnimalCardsIdentifier = "LernBio_AnimalCards"
    
    func startObservingPaymentQueue() { SKPaymentQueue.default().add(self) }
    func stopObservingPaymentQueue() { SKPaymentQueue.default().remove(self) }
    func canMakePayments() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    func buy(product: SKProduct, _ completion: @escaping PurchaseCompletionHandler) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        purchaseCompletionHandler = completion
    }
    
    func restorePurchases(_ completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


// MARK: - Fetch product objects from apple

extension StoreManager: SKProductsRequestDelegate {
    func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        fetchCompletionHandler = completion
        let request = SKProductsRequest(productIdentifiers: Set([StoreManager.buyAllAnimalCardsIdentifier]))
        request.delegate = self
        request.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            fetchCompletionHandler?(.success(products))
        } else {
            fetchCompletionHandler?(.failure(.noProductsFound))
        }
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        fetchCompletionHandler?(.failure(.productRequestFailed))
    }
}


// MARK: - Observe the transaction state

extension StoreManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            
            switch transaction.transactionState {
        
        case .purchased:
            isAnimalPackUnlocked = true
            purchaseCompletionHandler?(.success(true))
            SKPaymentQueue.default().finishTransaction(transaction)
        
        case .restored:
            isAnimalPackUnlocked = true
            purchaseCompletionHandler?(.success(true))
            SKPaymentQueue.default().finishTransaction(transaction)
            
        case .failed:
            if let error = transaction.error as? SKError {
                if error.code != .paymentCancelled {
                    purchaseCompletionHandler?(.failure(error))
                } else {
                    purchaseCompletionHandler?(.failure(GWBError.paymentWasCancelled))
                }
            }
            SKPaymentQueue.default().finishTransaction(transaction)
            
        case .deferred, .purchasing: break
        @unknown default: break
        }
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                purchaseCompletionHandler?(.failure(error))
            } else {
                purchaseCompletionHandler?(.failure(GWBError.paymentWasCancelled))
            }
        }
    }
    
    
    func showBuyAlert(on presentingVC: LoadingVC, for product: SKProduct) {
        guard let price = StoreManager.shared.getPriceFormatted(for: product) else { return }
        
        let ac = UIAlertController(title: "Belohne deinen Lern-Erfolg!", message: "Du hast die 3 gratis AnimalCards bereits freigespielt. Schalte jetzt 47 weitere liebevoll gestaltete AnimalCards zum Freispielen frei und belohne dein Lernen!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Kaufen für \(price)", style: .default, handler: { _ in
            presentingVC.showLoadingView()
            
            self.buy(product: product) { (result) in
                switch result {
                case .success(_):
                    self.isAnimalPackUnlocked = true
                    AnimalCardManager.shared.unlockNextAnimalCard()
                    AnimalCardManager.shared.showNewAnimalAlert(on: presentingVC)
                    presentingVC.dismissLoadingView()
                case .failure(let error):
                    presentingVC.dismissLoadingView()
                    let ac = UIAlertController(title: "Kauf fehlgeschlagen", message: "Leider war der Kauf nicht erfolgreich. Fehler: \(error)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        presentingVC.dismiss(animated: true)
                    }))
                    presentingVC.present(ac, animated: true, completion: nil)
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Nein, danke.", style: .cancel, handler: {(alert) in
            presentingVC.dismiss(animated: true, completion: nil)
        }))
        presentingVC.present(ac, animated: true, completion: nil)
    }
    
    
    func showParentalAlert(on presentingVC: UIViewController, completion: @escaping (UIAlertAction) -> Void) {
        let randomNumber = Int.random(in: 1...1000)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let numberAsWord = formatter.string(from: NSNumber(value: randomNumber))!
        
        
        let parentalAlert = UIAlertController(title: "Zeig diese Meldung deinen Eltern!", message: "Um weitere Cards freizuschalten, ist ein einmaliger In-App-Kauf von 2,29€ notwendig. Sie erwerben damit den Zugang zu 47 weiteren, liebevoll gestalteten Cards. Zur Bestätigung des Kaufs bitte das folgende Wort als Zahl in das Feld eingeben: \n\(String(describing: numberAsWord)) ", preferredStyle: .alert)
        parentalAlert.addTextField { (textfield) in
            textfield.placeholder = "Hier Zahl eingeben..."
            textfield.keyboardType = .numberPad
        }
        parentalAlert.addAction(UIAlertAction(title: "Fortfahren", style: .default, handler: { action in
            if let text = parentalAlert.textFields?.first?.text {
                if Int(text) == randomNumber {
                    completion(action)
                } else {
                    presentingVC.dismiss(animated: true, completion: nil)
                }
            }
        }))
        parentalAlert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        presentingVC.present(parentalAlert, animated: true, completion: nil)
    }
}


// MARK: - StoreError Type

enum GWBError: Error {
    case noProductsFound
    case paymentWasCancelled
    case productRequestFailed
}
