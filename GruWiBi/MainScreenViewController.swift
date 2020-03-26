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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "QuizView") as! QuizViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
