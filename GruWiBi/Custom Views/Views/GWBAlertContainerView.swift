//
//  GWBAlertContainerView.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 15.04.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class GWBAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor                           = .systemBackground
        layer.cornerRadius                        = 16
        layer.borderWidth                         = 2
        layer.borderColor                         = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
