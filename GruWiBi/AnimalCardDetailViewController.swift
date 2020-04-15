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
    lazy var animalFacts = [animal?.fact1, animal?.fact2, animal?.fact3]
    
    var scrollViewFrame = CGRect.zero
    var layoutMainColor: UIColor = .systemOrange

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var scientificName: UILabel!
    @IBOutlet weak var imageLicense: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        configureNameLabel()
        configureImageLicense()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureScrollView()
    }
    
    
    func configureImageView() {
        imageView.image = UIImage(named: animal?.image ?? "ameisenigel")
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = layoutMainColor.cgColor
        imageView.layer.borderWidth = 2
    }
    
    
    func configureImageLicense() {
        imageLicense.text = "Photo by \(animal?.authorImage ?? "Unknown") on \(animal?.imagePlatform ?? "")"
    }
    
    
    func configureNameLabel() {
        name.text = animal?.name
        name.textColor = layoutMainColor
        scientificName.text = animal?.nameScientific
        scientificName.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    
    func configureScrollView() {
        scrollView.contentSize = CGSize(width: (scrollView.frame.width) * 3, height: scrollView.frame.height)
        scrollView.delegate = self
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = layoutMainColor

        for index in 0...2 {
            scrollViewFrame.origin.x = scrollView.frame.size.width * CGFloat(index)
            scrollViewFrame.size = CGSize(width: scrollView.frame.width - 20, height: scrollView.frame.height)

            let factLabel = UILabel(frame: scrollViewFrame)
            factLabel.numberOfLines = 0
            factLabel.font = UIFont.preferredFont(forTextStyle: .body)
            factLabel.textColor = .systemGray
            factLabel.minimumScaleFactor = 0.5
            factLabel.adjustsFontSizeToFitWidth = true
            factLabel.textAlignment = .left
            factLabel.text = animalFacts[index]

            self.scrollView.addSubview(factLabel)
    }
}
}

extension AnimalCardDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}
