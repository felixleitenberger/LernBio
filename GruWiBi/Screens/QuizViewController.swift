//
//  ViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 12.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit
import StoreKit

class QuizViewController: LoadingVC {
    
    var questionSet = [Question]()
    var questionIndex = 0
    var score = 0
    var results = [Bool]()
    var questionPacks = [String]()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var statusBar: QuestionStatusBar!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionSet = Question.getQuestionSet(for: questionPacks)
        layoutQuestion()
        showQuestionImage()
        layoutButtons()
        layoutQuitButton()
        statusBar.configure()
        statusBar.active(for: questionIndex)
    }
    
    
    func layoutQuitButton() {
        quitButton.setImage(UIImage(named: "cancel"), for: .normal)
        quitButton.tintColor = .systemGray2
    }
    
    
    func layoutQuestion() {
        questionView.layer.borderColor = UIColor.systemGray2.cgColor
        questionView.layer.borderWidth = 1
        questionView.layer.cornerRadius = 10
        questionLabel.text = questionSet[questionIndex].question
    }
    
    
    func showQuestionImage() {
        if let image = questionSet[questionIndex].imageQuestion {
            guard image != "" else { return imageView.image = nil }
            imageView.image = UIImage(named: image)
        }
    }
    
    
    func layoutButtons() {
        for button in buttons {
            button.layer.borderColor = UIColor.systemGray2.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.backgroundColor = .clear
        }
        buttons.shuffle()
        buttons[0].setTitle(questionSet[questionIndex].correctAnswer, for: .normal)
        buttons[1].setTitle(questionSet[questionIndex].wrongAnswer1, for: .normal)
        buttons[2].setTitle(questionSet[questionIndex].wrongAnswer2, for: .normal)
        buttons[3].setTitle(questionSet[questionIndex].wrongAnswer3, for: .normal)
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        for button in buttons {
            button.isEnabled = false
        }
        
        results.append(checkAnswer(pressedButton: sender, buttonText: sender.titleLabel?.text))
        
        var time: Double
        
        if checkAnswer(pressedButton: sender, buttonText: sender.titleLabel?.text) {
            time = 0.5
            sender.backgroundColor = .systemGreen
            score += 1
            statusBar.rightAnswer(for: questionIndex)
        } else {
            time = 1.0
            sender.backgroundColor = .systemRed
            statusBar.wrongAnswer(for: questionIndex)
            
            for button in buttons {
                if button.titleLabel?.text == questionSet[questionIndex].correctAnswer {
                    button.layer.borderColor = UIColor.systemGreen.cgColor
                    button.layer.borderWidth = 3
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.nextQuestion()
        }
    }
    
    
    func checkAnswer(pressedButton: UIButton, buttonText: String?) -> Bool {
        if pressedButton.titleLabel?.text == questionSet[questionIndex].correctAnswer {
            return true
        } else {
            return false
        }
    }
    
    
    func nextQuestion() {
        if questionIndex == 13 {
            quitButton.isHidden = true
            statusBar.showLastStatusRect()
        }
        
        if questionIndex < 14 {
            statusBar.notActive(for: questionIndex)
            questionIndex += 1
            statusBar.active(for: questionIndex)
            layoutQuestion()
            showQuestionImage()
            layoutButtons()
        } else {
            questionView.isHidden = true
            for button in buttons {
                button.isHidden = true
            }
            questionView.isHidden = false
            questionView.layer.borderWidth = 0
            imageView.isHidden = true
            questionLabel.text = "Eine deiner Antworten wird zufällig ausgewählt... \nWenn die Antwort richtig ist, schaltest du eine Card frei."
            questionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            questionLabel.textColor = .systemGray
            evaluate()
        }
        
        for button in buttons {
            button.isEnabled = true
        }
    }
    
    
    func evaluate() {
        let relevantAnswerIndex = Int.random(in: 0...14)
        let isAnimalCardUnlocked = results[relevantAnswerIndex]
        
        statusBar.animateAfterQuiz(to: relevantAnswerIndex, completed: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.questionView.isHidden = true
                
                guard isAnimalCardUnlocked else {
                    let alertVC = GWBAlertVC(title: "Schade...", message: "Die zufällig ausgewählte Antwort war falsch.\nVersuch's einfach nochmal!", buttonTitle: "Zum Menü", animalCardImage: nil)
                    alertVC.buttonAction = {
                        self.dismiss(animated: true) {
                        }
                    }
                    self.present(alertVC, animated: true)
                    return
                }
                
                
                guard AnimalCardManager.shared.isThereAnyAnimalCardToUnlock() else {
                    let alertVC = GWBAlertVC(title: "Heavy Player, ha!", message: "Alle Cards sind schon freigeschaltet. Vielleicht kommen mit dem nächsten Update ja neue Cards!", buttonTitle: "Zum Menü", animalCardImage: nil)
                    alertVC.buttonAction = {
                        self.dismiss(animated: true) {
                        }
                    }
                    self.present(alertVC, animated: true)
                    return
                }
                
                AnimalCardManager.shared.unlockNextAnimalCard()
                    AnimalCardManager.shared.showNewAnimalAlert(on: self)
            }
        })
    }
    
    
    @IBAction func quitQuiz(_ sender: UIButton) {
        quitButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
}

