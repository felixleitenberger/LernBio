//
//  MainScreenViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 18.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit



class MainScreenViewController: UIViewController {
    @IBOutlet var containerView1: UIView!
    @IBOutlet var containerView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillContainerViews()
        layoutContainerViews()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func fillContainerViews() {
        if let startQuizVC = storyboard?.instantiateViewController(identifier: "StartQuizVC") as? StartQuizVC {
            startQuizVC.delegate = self
            add(childVC: startQuizVC, to: containerView1)
        }
        
        if let lastAnimalCardVC = storyboard?.instantiateViewController(identifier: "LastAnimalCardVC") as? LastAnimalCardVC {
            lastAnimalCardVC.delegate = self
            add(childVC: lastAnimalCardVC, to: containerView2)
        }
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func layoutContainerViews() {
        containerView1.layer.cornerRadius = 10
        containerView1.layer.masksToBounds = true
        containerView2.layer.cornerRadius = 10
        containerView2.layer.masksToBounds = true
    }
}


extension MainScreenViewController: StartQuizVCDelegate {
    func didStartQuiz(classes: [String]) {
        if classes.isEmpty {
            let alertVC = GWBAlertVC(title: "Keine Klasse ausgewählt", message: "Wähle mindestens eine Klasse aus.", buttonTitle: "OK", animalCardImage: nil)
            alertVC.buttonAction = { self.dismiss(animated: true)}
            present(alertVC, animated: true)
            return
        } else {
            let vc = self.storyboard?.instantiateViewController(identifier: "QuizView") as! QuizViewController
            vc.modalPresentationStyle = .fullScreen
            vc.questionPacks.append(contentsOf: classes)
            present(vc, animated: true)
        }
    }
}


extension MainScreenViewController: LastAnimalCardVCDelegate {
    func didTapShowCard() {
        if let vc = self.storyboard?.instantiateViewController(identifier: "Cards") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}






    
//    @IBAction func startButtonPressed(_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(identifier: "QuizView") as! QuizViewController
//        vc.modalPresentationStyle = .fullScreen
//
//        if !B5.isOn && !B6.isOn && !B8.isOn {
//            let alertVC = GWBAlertVC(title: "Keine Klasse ausgewählt", message: "Wähle mindestens eine Klasse aus.", buttonTitle: "OK", animalCardImage: nil)
//            alertVC.buttonAction = { self.dismiss(animated: true)}
//            present(alertVC, animated: true)
//            return
//        }
//        if B5.isOn { vc.questionPacks.append("B5+") }
//        if B6.isOn { vc.questionPacks.append("B6+") }
//        if B8.isOn { vc.questionPacks.append("B8+") }
//
//        present(vc, animated: true, completion: nil)
//    }
//    @IBOutlet var welcomeView: UIView!
//    @IBOutlet var welcomeImage: UIImageView!
//
//    @IBOutlet var lastCardImage: UIImageView!
//    @IBOutlet var lastCardName: UILabel!
//    @IBOutlet var cardView: UIView!
//    @IBOutlet var cardStack: UIStackView!
//    @IBOutlet var quizSelectionView: UIView!
//    @IBOutlet var startButton: GWBButton!
//
//    @IBOutlet var B5: UISwitch!
//    @IBOutlet var B6: UISwitch!
//    @IBOutlet var B8: UISwitch!
//
//
//    func getLastCard() {
//        let cards = AnimalCardManager.shared.getUnlockedAnimalCards()
//
//        if let lastCard = cards.last {
//            cardView.isHidden = false
//            welcomeView.isHidden = true
//            lastCardImage.image = UIImage(named: lastCard.imageLogo)
//            lastCardName.text = lastCard.name
//        } else {
//            cardView.isHidden = true
//            welcomeView.isHidden = false
//            animatedImagesWelcome()
//        }
//    }
//
//
//    func configureLayoutOfWelcomeView() {
//        welcomeView.layer.cornerRadius = 20
//        welcomeView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 20).cgPath
//        welcomeView.layer.shadowColor = UIColor.label.cgColor
//        welcomeView.layer.shadowOpacity = 0.5
//        welcomeView.layer.shadowOffset = .zero
//    }
//
//
//    func animatedImagesWelcome() {
//        var i = 1
//        var images = [UIImage]()
//
//        while let image = UIImage(named: "welcome\(i)") {
//            images.append(image)
//            i += 1
//        }
//        welcomeImage.animationImages = images
//        welcomeImage.animationDuration = 5
//        welcomeImage.image = welcomeImage.animationImages?.first
//        welcomeImage.startAnimating()
//    }
//
//
//    func configureLayoutOfCardView() {
//        cardStack.layer.cornerRadius = 10
//
//        cardView.layer.cornerRadius = 20
//        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 20).cgPath
//        cardView.layer.shadowColor = UIColor.label.cgColor
//        cardView.layer.shadowOpacity = 0.5
//        cardView.layer.shadowOffset = .zero
//    }
//
//    func configureQuizSelectionView() {
//        quizSelectionView.layer.cornerRadius = 20
//        quizSelectionView.layer.shadowPath = UIBezierPath(roundedRect: quizSelectionView.bounds, cornerRadius: 20).cgPath
//        quizSelectionView.layer.shadowColor = UIColor.label.cgColor
//        quizSelectionView.layer.shadowOpacity = 0.5
//        quizSelectionView.layer.shadowOffset = .zero
//    }



