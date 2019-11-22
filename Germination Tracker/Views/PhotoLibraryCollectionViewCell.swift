//
//  PhotoLibraryCollectionViewCell.swift
//  Germinate
//
//  Created by Joshua on 11/22/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    /// Image view for the cell.
    var imageView = UIImageView()
    
    func setCellImageTo(_ image: UIImage) {
        imageView.image = image
    }
}
