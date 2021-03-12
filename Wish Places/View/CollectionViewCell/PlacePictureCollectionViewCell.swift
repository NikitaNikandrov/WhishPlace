//
//  PlacePictureCollectionViewCell.swift
//  HobPl
//
//  Created by Никита on 12.12.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import UIKit
import SkeletonView

class PlacePictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placePicture.isSkeletonable = true
    }
    
    func loadCell(imageURL: String ) {
        self.placePicture.showAnimatedSkeleton()
        guard let url = URL(string: imageURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.placePicture.image = image
                self?.placePicture.hideSkeleton()
            }
        }
        task.resume()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.placePicture.isHidden = true
    }
}
