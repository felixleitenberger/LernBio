//
//  ViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 12.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    var questionList = [Question]()
    var actualQuestionSet = [Question]()
    var actualQuestionIndex = 0
    var score = 0
    
    var sizeOfStatusBar = CGFloat()
    var statusRects = [CAShapeLayer]()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestions(for: "B5+")
        chooseRandomQuestionSet()
        layoutQuestionView()
        startOverButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sizeOfStatusBar = statusBar.frame.width
        drawStatusRects()
        layoutButtons()
    }
    
    
    func getQuestions(for selectedGrades: String...) {
        for grade in selectedGrades {
            questionList += Question.get(for: grade)
        }
    }
    
    func chooseRandomQuestionSet() {
        for _ in 0...14 {
            let randomIndex = Int.random(in: 0..<(questionList.count))
            let randomQuestion = questionList.remove(at: randomIndex)
            actualQuestionSet.append(randomQuestion)
            actualQuestionSet.shuffle()
        }
    }
    
    func layoutQuestionView() {
        questionView.layer.borderColor = UIColor.systemGray2.cgColor
        questionView.layer.borderWidth = 1
        questionView.layer.cornerRadius = 10
    }
    
    func layoutButtons() {
        for button in buttons {
            button.layer.borderColor = UIColor.systemGray2.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.backgroundColor = .clear
        }
        
        statusRects[actualQuestionIndex].strokeColor = UIColor.systemOrange.cgColor
        statusRects[actualQuestionIndex].lineWidth = 2
        
        buttons.shuffle()
        questionLabel.text = actualQuestionSet[actualQuestionIndex].question
        
        if let image = actualQuestionSet[actualQuestionIndex].imageQuestion {
            imageView.image = UIImage(named: image)
        }
        buttons[0].setTitle(actualQuestionSet[actualQuestionIndex].correctAnswer, for: .normal)
        buttons[1].setTitle(actualQuestionSet[actualQuestionIndex].wrongAnswer1, for: .normal)
        buttons[2].setTitle(actualQuestionSet[actualQuestionIndex].wrongAnswer2, for: .normal)
        buttons[3].setTitle(actualQuestionSet[actualQuestionIndex].wrongAnswer3, for: .normal)
    }
    
    func drawStatusRects() {
        for number in 0...14 {
            let layer = CAShapeLayer()
            let sizeOfRect = Double(sizeOfStatusBar / 15.0)
            let xPos = (sizeOfRect * Double(number)) + 2
            layer.path = UIBezierPath(roundedRect: CGRect(x: xPos, y: 0, width: sizeOfRect - 4, height: sizeOfRect / 2), cornerRadius: 3).cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 1
            layer.strokeColor = UIColor.systemGray2.cgColor
            statusRects.append(layer)
            statusBar.layer.addSublayer(layer)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        for button in buttons {
            button.isEnabled = false
        }
        
        if checkAnswer(pressedButton: sender, buttonText: sender.titleLabel?.text) {
            sender.backgroundColor = .systemGreen
            score += 1
            statusRects[actualQuestionIndex].fillColor = UIColor.systemGreen.cgColor
            statusRects[actualQuestionIndex].strokeColor = UIColor.systemGray2.cgColor
            statusRects[actualQuestionIndex].lineWidth = 1
        } else {
            sender.backgroundColor = .systemRed
            statusRects[actualQuestionIndex].fillColor = UIColor.systemRed.cgColor
            statusRects[actualQuestionIndex].strokeColor = UIColor.systemGray2.cgColor
            statusRects[actualQuestionIndex].lineWidth = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.nextQuestion()
        }
    }
    
    func checkAnswer(pressedButton: UIButton, buttonText: String?) -> Bool {
        if pressedButton.titleLabel?.text == actualQuestionSet[actualQuestionIndex].correctAnswer {
            return true
        } else {
            return false
        }
    }
    
    func nextQuestion() {
        if actualQuestionIndex < 14 {
            actualQuestionIndex += 1
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
        getQuestions(for: "B5+")
        chooseRandomQuestionSet()
        score = 0
        actualQuestionIndex = 0
        startOverButton.isHidden = true
        for button in buttons {
            button.isHidden = false
        }
        for rect in statusRects {
            rect.fillColor = UIColor.clear.cgColor
        }
        questionView.isHidden = false
        layoutButtons()
    }
}

