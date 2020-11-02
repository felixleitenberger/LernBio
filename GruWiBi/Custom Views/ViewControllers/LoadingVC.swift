//
//  LoadingVC.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 07.10.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

        var containerView: UIView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        func showLoadingView() {
            containerView = UIView(frame: view.bounds)
            view.addSubview(containerView)
            
            containerView.backgroundColor   = .systemBackground
            containerView.alpha             = 0
            
            UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ])
            
            activityIndicator.startAnimating()
        }
        
        
        func dismissLoadingView() {
            DispatchQueue.main.async {
                self.containerView.removeFromSuperview()
                self.containerView = nil
            }
        }
}
