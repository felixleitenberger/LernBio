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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        for number in 0...14 {
            let layer = CAShapeLayer()
            let sizeOfRect = Double(self.frame.width / 15.0)
            let xPos = (sizeOfRect * Double(number)) + 2
            layer.path = UIBezierPath(roundedRect: CGRect(x: xPos, y: 0, width: sizeOfRect - 4, height: sizeOfRect / 2), cornerRadius: 3).cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 1
            layer.strokeColor = UIColor.systemGray2.cgColor
            statusRects.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    
    func active(for index: Int) {
        statusRects[index].strokeColor = UIColor.systemOrange.cgColor
        statusRects[index].lineWidth = 2
    }
    
    func notActive(for index: Int) {
        statusRects[index].strokeColor = UIColor.systemGray2.cgColor
        statusRects[index].lineWidth = 1
    }
    
    func rightAnswer(for index: Int) {
        statusRects[index].fillColor = UIColor.systemGreen.cgColor
        statusRects[index].strokeColor = UIColor.systemGray2.cgColor
        statusRects[index].lineWidth = 1
    }
    
    func wrongAnswer(for index: Int) {
        statusRects[index].fillColor = UIColor.systemRed.cgColor
        statusRects[index].strokeColor = UIColor.systemGray2.cgColor
        statusRects[index].lineWidth = 1
    }
    
    func reset() {
        for rect in statusRects {
         rect.fillColor = UIColor.clear.cgColor
        }
    }
}
