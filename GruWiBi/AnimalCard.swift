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
    
    static func parseAnimalCardList() -> [AnimalCard] {
        var animalCardList = [AnimalCard]()
        if let url = Bundle.main.url(forResource: "animalCards", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
                animalCardList = try jsonDecoder.decode([AnimalCard].self, from: jsonData)
            } catch {
                fatalError()
            }
        }
        return animalCardList
    }
}
