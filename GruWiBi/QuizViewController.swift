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
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var statusBar: QuestionStatusBar!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionSet = Question.getQuestionSet(for: "B5+")
        startOverButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statusBar.configure()
        statusBar.active(for: questionIndex)
        layoutQuestion()
        showQuestionImage()
        layoutButtons()
    }
    
    func layoutQuestion() {
        questionView.layer.borderColor = UIColor.systemGray2.cgColor
        questionView.layer.borderWidth = 1
        questionView.layer.cornerRadius = 10
        questionLabel.text = questionSet[questionIndex].question
    }
    
    func showQuestionImage() {
        if let image = questionSet[questionIndex].imageQuestion {
                 guard image != "" else { return }
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
            let alert = UIAlertController(title: "Fertig", message: "Du hast \(score) von 15 richtig beantwortet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            startOverButton.isHidden = false
        }
        
        for button in buttons {
            button.isEnabled = true
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    func startNewGame() {
        questionSet = Question.getQuestionSet(for: "B5+")
        score = 0
        questionIndex = 0
        startOverButton.isHidden = true
        for button in buttons {
            button.isHidden = false
        }
        
        questionView.isHidden = false
        
        statusBar.reset()
        statusBar.active(for: questionIndex)
        layoutQuestion()
        showQuestionImage()
        layoutButtons()
    }
}

