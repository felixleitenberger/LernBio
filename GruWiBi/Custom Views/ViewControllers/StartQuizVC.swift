//
//  StartQuizVC.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 10.11.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

protocol StartQuizVCDelegate: class {
    func didStartQuiz(classes: [String])
}


@IBDesignable class StartQuizVC: UIViewController {

    @IBOutlet var selectorView: UIView!
    @IBOutlet var startQuizButton: UIButton!
    
    @IBOutlet var B5: UIButton!
    @IBOutlet var B6: UIButton!
    @IBOutlet var B8: UIButton!
    
    weak var delegate: StartQuizVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configure()
    }
    
    func configure() {
        B5.layer.cornerRadius = 16
        B6.layer.cornerRadius = 16
        B8.layer.cornerRadius = 16
    }
    
    @IBAction func b5pressed(_ sender: Any) {
        B5.isSelected.toggle()
        if B5.isSelected {
            B5.backgroundColor = .systemGreen
            B5.layer.sublayers?.removeLast()
        } else {
            B5.backgroundColor = .none
            B5.addLineDashedStroke(pattern: [2, 2], radius: 16, color: UIColor.lightGray.cgColor)
        }
        
    }
    
    @IBAction func b6pressed(_ sender: Any) {
        B6.isSelected.toggle()
        if B6.isSelected {
            B6.backgroundColor = .systemGreen
            B6.layer.sublayers?.removeLast()
        } else {
            B6.backgroundColor = .none
            B6.addLineDashedStroke(pattern: [2, 2], radius: 16, color: UIColor.lightGray.cgColor)
        }
    }
    
    @IBAction func b8pressed(_ sender: Any) {
        B8.isSelected.toggle()
        if B8.isSelected {
            B8.backgroundColor = .systemGreen
            B8.layer.sublayers?.removeLast()
        } else {
            B8.backgroundColor = .none
            B8.addLineDashedStroke(pattern: [2, 2], radius: 16, color: UIColor.lightGray.cgColor)
        }
    }
    
    @IBAction func startQuizPressed(_ sender: Any) {
        var selectedClasses = [String]()
        if B5.isSelected { selectedClasses.append("B5+")}
        if B6.isSelected { selectedClasses.append("B6+")}
        if B8.isSelected { selectedClasses.append("B8+")}
        
        delegate.didStartQuiz(classes: selectedClasses)
    }
}
