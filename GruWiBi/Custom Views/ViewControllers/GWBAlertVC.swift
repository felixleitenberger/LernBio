//
//  GWBAlertVC.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 15.04.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class GWBAlertVC: UIViewController {
    
    let containerView   = GWBAlertContainerView()
    let titleLabel      = GWBTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel    = GWBBodyLabel(textAlignment: .center)
    let actionButton    = GWBButton(backgroundColor: .systemPink, title: "Ok")
    let imageView       = UIImageView()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var animalCardImage: UIImage?
    
    var buttonAction: (() -> Void)?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String, animalCardImage: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle         = title
        self.message            = message
        self.buttonTitle        = buttonTitle
        self.animalCardImage    = animalCardImage
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView, titleLabel, messageLabel, actionButton, imageView)
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureImageView()
        configureActionButton()
    }
    
    
    func configureContainerView() {
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }
    
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Irgendwas lief schief..."
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    
    func configureMessageLabel() {
        messageLabel.text               = message ?? "Irgendwas lief schief..."
        messageLabel.numberOfLines      = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
    
    
    func configureImageView() {
        imageView.image = animalCardImage ?? UIImage(named: "pixel")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
        buttonAction?()
    }
}
