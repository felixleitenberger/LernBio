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

// MARK: - Store API

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
}


// MARK: - StoreError Type

enum GWBError: Error {
    case noProductsFound
    case paymentWasCancelled
    case productRequestFailed
}
