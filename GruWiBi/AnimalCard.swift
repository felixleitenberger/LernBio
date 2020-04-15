//
//  AnimalCard.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 25.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import Foundation

struct AnimalCard: Codable {
    let name: String
    let nameScientific: String
    let image: String
    let fact1: String
    let fact2: String
    let fact3: String
    let authorImage: String
    let imagePlatform: String
    let authorLink: String
    let platformLink: String
    let imageLogo: String
    
    
    /// Loads the json from Bundle and returns an Array of AnimalCard objects
    
    static func getAllAnimalCards() -> [AnimalCard] {
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
    
    
    static func unlockNextAnimalCard(){
        let defaults = UserDefaults.standard
        var unlockedAnimalCardsIndices = defaults.array(forKey: "UnlockedAnimalCards") as? [Int] ?? [Int]()
        
        if getAllAnimalCards().count > unlockedAnimalCardsIndices.count {
            unlockedAnimalCardsIndices.append(unlockedAnimalCardsIndices.count)
            defaults.set(unlockedAnimalCardsIndices, forKey: "UnlockedAnimalCards")
        }
    }
    
    
    static func getUnlockedAnimalCards() -> [AnimalCard] {
        let defaults = UserDefaults.standard
        let unlockedAnimalCardIndices = defaults.array(forKey: "UnlockedAnimalCards") as? [Int] ?? [Int]()
        let allAnimalCards = getAllAnimalCards()
        var unlockedAnimalCards = [AnimalCard]()
        
        for index in unlockedAnimalCardIndices {
            unlockedAnimalCards.append(allAnimalCards[index])
        }
        return unlockedAnimalCards
    }
}
