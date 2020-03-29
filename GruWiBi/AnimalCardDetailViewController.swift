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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var scientificName: UILabel!
    @IBOutlet weak var fact1: UILabel!
    @IBOutlet weak var fact2: UILabel!
    @IBOutlet weak var fact3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: animal?.image ?? "ameisenigel")
        name.text = animal?.name
        scientificName.text = animal?.nameScientific
        fact1.text = animal?.fact1
        fact2.text = animal?.fact2
        fact3.text = animal?.fact3
        

    }
}
