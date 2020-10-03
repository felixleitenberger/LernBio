//
//  MainScreenViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 18.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        getLastCard()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        configureQuizSelectionView()
        configureLayoutOfCardView()
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "QuizView") as! QuizViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet var lastCardImage: UIImageView!
    @IBOutlet var lastCardName: UILabel!
    @IBOutlet var cardView: UIView!
    @IBOutlet var cardStack: UIStackView!
    @IBOutlet var quizSelectionView: UIView!
    
    
    func getLastCard() {
        let cards = AnimalCard.getUnlockedAnimalCards()
        
        if let lastCard = cards.last {
            cardView.isHidden = false
            lastCardImage.image = UIImage(named: lastCard.imageLogo)
            lastCardName.text = lastCard.name
        } else {
            cardView.isHidden = true
        }
    }
    
    
    func configureLayoutOfCardView() {
        cardStack.layer.cornerRadius = 10
        
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 20).cgPath
        cardView.layer.shadowColor = UIColor.label.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = .zero
    }
    
    func configureQuizSelectionView() {
        quizSelectionView.layer.cornerRadius = 20
        quizSelectionView.layer.shadowPath = UIBezierPath(roundedRect: quizSelectionView.bounds, cornerRadius: 20).cgPath
        quizSelectionView.layer.shadowColor = UIColor.label.cgColor
        quizSelectionView.layer.shadowOpacity = 0.5
        quizSelectionView.layer.shadowOffset = .zero
    }
}


