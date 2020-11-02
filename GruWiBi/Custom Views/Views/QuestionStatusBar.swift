//
//  QuestionStatusBar.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 16.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class QuestionStatusBar: UIView {
    
    @IBOutlet var statusRects: [UIView]!
    
    var timer: Timer?
    var timer2: Timer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func configure() {
        for rect in statusRects {
            rect.layer.cornerRadius = 3
            rect.layer.borderWidth = 1
            rect.layer.borderColor = UIColor.systemGray2.cgColor
        }
        statusRects[14].layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func active(for index: Int) {
        statusRects[index].layer.borderColor = UIColor.systemOrange.cgColor
        statusRects[index].layer.borderWidth = 2
    }
    
    
    func notActive(for index: Int) {
        statusRects[index].layer.borderColor = UIColor.clear.cgColor
        statusRects[index].layer.borderWidth = 1
    }
    
    
    func rightAnswer(for index: Int) {
        statusRects[index].backgroundColor = UIColor.systemGreen
        statusRects[index].layer.borderColor = UIColor.clear.cgColor
        statusRects[index].layer.borderWidth = 1
    }
    
    
    func wrongAnswer(for index: Int) {
        statusRects[index].backgroundColor = UIColor.systemRed
        statusRects[index].layer.borderColor = UIColor.clear.cgColor
        statusRects[index].layer.borderWidth = 1
    }
    
    
    func showLastStatusRect() {
        statusRects[14].layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    
    func animateAfterQuiz(to index: Int, completed: @escaping () ->()) {
        var countOn = 0
        var countOff = 0
        var round = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { t in
            UIView.animate(withDuration: 0.08, delay: 0, animations: {
                self.statusRects[countOn].transform = CGAffineTransform(translationX: 0, y: 10)
            })
            countOn += 1

            if countOn == 15 {
                round += 1
                countOn = 0
            }

            if round >= 2 {
                t.invalidate()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.timer2 = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true){ t in
                UIView.animate(withDuration: 0.08, delay: 0, animations: {
                self.statusRects[countOff].transform = CGAffineTransform(translationX: 0, y: 0)
                })
                countOff += 1
                if countOff == 15 {
                    countOff = 0
                }

                if round >= 2 && countOff == 0 {
                    t.invalidate()
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){t in
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                            self.statusRects[countOn].transform = CGAffineTransform(translationX: 0, y: 10)
                        })
                        if countOn == index {
                            t.invalidate()

                        }
                        countOn += 1
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.timer2 = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){ t in
                            if countOff >= index {
                                t.invalidate()
                                completed()
                            } else {
                                UIView.animate(withDuration: 0.2, delay: 0, animations: {
                                self.statusRects[countOff].transform = CGAffineTransform(translationX: 0, y: 0)
                                })
                                countOff += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func reset() {
        for rect in statusRects {
            rect.backgroundColor = UIColor.clear
        }
    }
}
