//
//  DetailViewController.swift
//  HobPl
//
//  Created by Никита on 16.07.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import UIKit
import SkeletonView

class DetailViewController: UIViewController {
    
    let networkService = NetworkService()
    var selectedPlaceName = "" // имя выбранного места, передается при нажатии на ячейку головного table view
    var indexOfItem = 0
    var imageURLs: [String] = []
    
    @IBOutlet weak var placePictureCollectionView: UICollectionView!
    @IBOutlet weak var noteButton: UIButton!
    
    @IBAction func noteButtonIsPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let noteOfPlaceViewController = storyboard.instantiateViewController(identifier: "NoteOfPlaceViewController") as? NoteOfPlaceViewController else { return }
        noteOfPlaceViewController.placeIndex = indexOfItem
        self.present(noteOfPlaceViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstSetupDeteilViewController()
        
        self.placePictureCollectionView.register(UINib(nibName: "PlacePictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCollectionViewCell")
        self.placePictureCollectionView.dataSource = self
        self.placePictureCollectionView.delegate = self
        
        networkService.getPictureURL(name: selectedPlaceName) { (result) in
            
            guard let result = result else {
                self.getErrorPictureAllertController() // появляется предупреждения об отсутствии картинки
                return
            }
            self.imageURLs = result // переписываю ссылки на картинки
            DispatchQueue.main.sync {
                self.placePictureCollectionView.reloadData()
            }
        }
    }
    
    func firstSetupDeteilViewController() {
        let title = "My notes of " + self.selectedPlaceName
        self.noteButton.setTitle(title, for: .normal)
    }
    
    func getErrorPictureAllertController() {
        let errorPictureAllert = UIAlertController(title: "Could't find a picture :(", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default) { (alert) in
            // ничего не делается по кнопке ок
        }
        errorPictureAllert.addAction(okBtn)
        DispatchQueue.main.async {
            self.present(errorPictureAllert, animated: true, completion: nil)
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PlacePictureCollectionViewCell
        
        cell.loadCell(imageURL: self.imageURLs[indexPath.item])
        cell.placePicture.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (placePictureCollectionView.bounds.width-4)/3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let bigPictureVC = storyboard.instantiateViewController(identifier: "BigPictureViewController") as? BigPictureViewController else { return }
        bigPictureVC.imageURLs = imageURLs
        bigPictureVC.selectedItemIndex = indexPath.item
        show(bigPictureVC, sender: nil)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PlacePictureCollectionViewCell"
    }
}
