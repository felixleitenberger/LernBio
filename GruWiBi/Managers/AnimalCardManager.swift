//
//  AnimalCardManager.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 06.10.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit
import StoreKit

class AnimalCardManager {
    static let shared = AnimalCardManager()
    
    var allAnimalCards: [AnimalCard]!
    var unlockedAnimalCardsIndices: [Int]!
    
    private init() {
        allAnimalCards = getAllAnimalCards()
        unlockedAnimalCardsIndices = getIndicesOfUnlockedAnimalCards()
    }
    
    func getAllAnimalCards() -> [AnimalCard] {
        var allAnimalCardList = [AnimalCard]()
        if let url = Bundle.main.url(forResource: "animalCards", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
                allAnimalCardList = try jsonDecoder.decode([AnimalCard].self, from: jsonData)
            } catch {
                fatalError()
            }
        }
        return allAnimalCardList
    }
    
    
    func getIndicesOfUnlockedAnimalCards() -> [Int] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "UnlockedAnimalCards") as? [Int] ?? []
    }
    
    
    func isThereAnyAnimalCardToUnlock() -> Bool {
        return allAnimalCards.count > unlockedAnimalCardsIndices.count ? true : false
    }
    
    
    func unlockNextAnimalCard() {
        guard isThereAnyAnimalCardToUnlock() else { return }
        unlockedAnimalCardsIndices.append(unlockedAnimalCardsIndices.count)
        let defaults = UserDefaults.standard
        defaults.set(unlockedAnimalCardsIndices, forKey: "UnlockedAnimalCards")
    }
    
    
    func getUnlockedAnimalCards() -> [AnimalCard] {
        var unlockedAnimalCards = [AnimalCard]()
        for index in unlockedAnimalCardsIndices {
            unlockedAnimalCards.append(allAnimalCards[index])
        }
        return unlockedAnimalCards
    }
    
    
    func showNewAnimalAlert(on presentingVC: UIViewController) {
        if let animal = getUnlockedAnimalCards().last {
            let alertVC = GWBAlertVC(title: "Card freigeschaltet!", message: "Herzlichen Glückwunsch! Ein neues Tier befindet sich in deinen Cards.\nEs heißt \(animal.name).", buttonTitle: "Cool! Zu den Cards!", animalCardImage: UIImage(named: animal.imageLogo))
            alertVC.buttonAction = {
                alertVC.dismiss(animated: true) {
                    if let vc = presentingVC.storyboard?.instantiateViewController(identifier: "Cards") {
                        if let navController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController as? UINavigationController {
                            presentingVC.dismiss(animated: true, completion: nil)
                            navController.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            presentingVC.present(alertVC, animated: true)
        }
    }
}
