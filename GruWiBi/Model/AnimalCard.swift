//
//  AnimalCard.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 25.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit
import StoreKit

class AnimalCard: Codable {
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
}
