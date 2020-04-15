//
//  QuestionStatusBar.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 16.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class QuestionStatusBar: UIView {
    
    var statusRects = [CAShapeLayer]()
    var timer: Timer?
    var timer2: Timer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        for number in 0...14 {
            let layer = CAShapeLayer()
            let sizeOfRect = Double(self.frame.width / 15.0)
            let heightOfView = Double(self.frame.height)
            let xPos = (sizeOfRect * Double(number)) + 2
            layer.path = UIBezierPath(roundedRect: CGRect(x: xPos, y: heightOfView / 2 - 5, width: sizeOfRect - 4, height: sizeOfRect / 2), cornerRadius: 3).cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 1
            layer.strokeColor = UIColor.systemGray2.cgColor
            statusRects.append(layer)
            self.layer.addSublayer(layer)
            
            if number == 14 {
                layer.isHidden = true
            }
        }
    }
    
    
    func active(for index: Int) {
        statusRects[index].strokeColor = UIColor.systemOrange.cgColor
        statusRects[index].lineWidth = 2
    }
    
    
    func notActive(for index: Int) {
        statusRects[index].strokeColor = UIColor.clear.cgColor
        statusRects[index].lineWidth = 1
    }
    
    
    func rightAnswer(for index: Int) {
        statusRects[index].fillColor = UIColor.systemGreen.cgColor
        statusRects[index].strokeColor = UIColor.clear.cgColor
        statusRects[index].lineWidth = 1
    }
    
    
    func wrongAnswer(for index: Int) {
        statusRects[index].fillColor = UIColor.systemRed.cgColor
        statusRects[index].strokeColor = UIColor.clear.cgColor
        statusRects[index].lineWidth = 1
    }
    
    
    func showLastStatusRect() {
        statusRects[14].isHidden = false
    }
    
    
    func animateAfterQuiz(to index: Int, completed: @escaping () ->()) {
        var countOn = 0
        var countOff = 0
        var round = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true){ t in
            self.statusRects[countOn].transform = CATransform3DMakeScale(1, 1.5, 1)
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
                self.statusRects[countOff].transform = CATransform3DMakeScale(1, 1, 1)
                countOff += 1
                if countOff == 15 {
                    countOff = 0
                }
                
                if round >= 2 && countOff == 0 {
                    t.invalidate()
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){t in
                        self.statusRects[countOn].transform = CATransform3DMakeTranslation(0, 20, 0)
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
                                self.statusRects[countOff].transform = CATransform3DMakeScale(1, 1, 1)
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
            rect.fillColor = UIColor.clear.cgColor
        }
    }
}
