//
//  AnimalCardsViewController.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 25.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import UIKit

class AnimalCardsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var animalCards = [AnimalCard]()
    private let spacing: CGFloat = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animalCards = AnimalCard.parseAnimalCardList()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let layout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
               layout.minimumLineSpacing = spacing
               layout.minimumInteritemSpacing = spacing
               self.collectionView?.collectionViewLayout = layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animalCards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCell", for: indexPath) as! AnimalCell
        cell.logoImage.image = UIImage(named: animalCards[indexPath.row].imageLogo)
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(identifier: "animalCardDetail") as! AnimalCardDetailViewController
        detailVC.animal = animalCards[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let numberOfItemsPerRow: CGFloat = 3
                let spacingBetweenCells: CGFloat = 16
               
                let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
               
                if let collection = self.collectionView{
                   let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                   return CGSize(width: width, height: width)
               } else {
                   return CGSize(width: 0, height: 0)
               }
    }
    
}
