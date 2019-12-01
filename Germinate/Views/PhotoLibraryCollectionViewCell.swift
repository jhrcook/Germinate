//
//  PhotoLibraryCollectionViewCell.swift
//  Germinate
//
//  Created by Joshua on 11/22/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    /// Image view for the cell.
    var imageView = UIImageView()
    
    private var cellHasBeenSetup = false
    
    func setCellImageTo(_ image: UIImage) {
        if !cellHasBeenSetup { setupCell() }
        imageView.image = image
    }
    
    private func setupCell() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in make.edges.equalTo(self) }
    }
}
