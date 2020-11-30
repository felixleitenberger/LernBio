//
//  LastAnimalCardVC.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 10.11.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

protocol LastAnimalCardVCDelegate: class {
    func didTapShowCard()
}

class LastAnimalCardVC: UIViewController {

    @IBOutlet var lastAnimalCardStackView: UIStackView!
    @IBOutlet var animalImage: UIImageView!
    @IBOutlet var animalLabel: UILabel!
    
    weak var delegate: LastAnimalCardVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastCard()
        lastAnimalCardStackView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLastCard()
    }

        func getLastCard() {
            let cards = AnimalCardManager.shared.getUnlockedAnimalCards()
    
            if let lastCard = cards.last {
                animalImage.image = UIImage(named: lastCard.imageLogo)
                animalLabel.text = lastCard.name
            } else {
                print("No cards")
            }
        }
    
    @IBAction func showAnimalCardsButtonTapped(_ sender: Any) {
        delegate.didTapShowCard()
    }
}
