//
//  AnimalCardDetailViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 25.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class AnimalCardDetailViewController: UIViewController {
    
    var animal: AnimalCard?

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: animal?.image ?? "ameisenigel")
    }
}
