//
//  BigPictureViewController.swift
//  Whish Places
//
//  Created by Никита on 07.03.2021.
//  Copyright © 2021 BmjCstms. All rights reserved.
//

import UIKit
import SkeletonView

class BigPictureViewController: UIViewController {
    
    @IBOutlet weak var bigPictureCollectionView: UICollectionView!
    
    var imageURLs: [String]?
    var selectedItemIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bigPictureCollectionView.register(UINib(nibName: "PlacePictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCollectionViewCell")
        self.bigPictureCollectionView.delegate = self
        self.bigPictureCollectionView.dataSource = self
        
        collectionViewFirstSetup()
    }
    
    func collectionViewFirstSetup() {
        self.bigPictureCollectionView.layoutIfNeeded()
        self.bigPictureCollectionView.scrollToItem(at: IndexPath(item: selectedItemIndex!, section: 0), at: .left, animated: true)
        self.bigPictureCollectionView.reloadData()
    }
}

extension BigPictureViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PlacePictureCollectionViewCell
        cell.loadCell(imageURL: self.imageURLs![indexPath.item])
        cell.placePicture.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = bigPictureCollectionView.bounds.width
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PlacePictureCollectionViewCell"
    }
}
