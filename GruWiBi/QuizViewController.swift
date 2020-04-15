//
//  ViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 12.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    var questionSet = [Question]()
    var questionIndex = 0
    var score = 0
    var results = [Bool]()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var statusBar: QuestionStatusBar!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionSet = Question.getQuestionSet(for: "B5+", "B8+")
        layoutQuestion()
        showQuestionImage()
        layoutButtons()
        layoutQuitButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statusBar.configure()
        statusBar.active(for: questionIndex)
    }
    
    
    func layoutQuitButton() {
        quitButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
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
        
        if checkAnswer(pressedButton: sender, buttonText: sender.titleLabel?.text) {
            sender.backgroundColor = .systemGreen
            score += 1
            statusBar.rightAnswer(for: questionIndex)
        } else {
            sender.backgroundColor = .systemRed
            statusBar.wrongAnswer(for: questionIndex)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
            questionLabel.text = "Eine deiner Antworten wird zufällig ausgewählt..."
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
        
        if results[relevantAnswerIndex] {
            AnimalCard.unlockNextAnimalCard()
            print("AnimalCardUnlocked")
        }
        
        var title: String {
            if results[relevantAnswerIndex] {
                return "Glückwunsch!"
            } else {
                return "Schade..."
            }
        }
        
        var message: String {
            if results[relevantAnswerIndex] {
                return "Frage \(relevantAnswerIndex + 1) wurde ausgewählt.\nSie wurde richtig beantwortet!\nSuper! Du hast eine Animal-Card freigeschaltet!"
            } else {
                return "Frage \(relevantAnswerIndex + 1) wurde ausgewählt.\nSie wurde leider falsch beantwortet!\nVersuch's doch einfach nochmal."
            }
        }
        
        statusBar.animateAfterQuiz(to: relevantAnswerIndex, completed: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true)
                self.questionView.isHidden = true
            }
        })
    }
    
    
    @IBAction func quitQuiz(_ sender: UIButton) {
        quitButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
}

