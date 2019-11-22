//
//  PhotoLibraryCollectionViewController.swift
//  Germinate
//
//  Created by Joshua on 11/22/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit


class PhotoLibraryCollectionViewController: UICollectionViewController {

    /// The plant for which to show images.
    var plant: Plant
    
    /// The reuse identifier for cells.
    private let reuseIdentifier = "photoCell"
    
    /// Images to present in the cells.
    var images = [UIImage]()
    
    /// The size of each collection view cell.
    var cellSize: CGSize {
        get {
            CGSize(width: collectionView.frame.width / 3.0,
                   height: collectionView.frame.width / 3.0)
        }
    }
    
    
    /// A gray label that appears in the center when no images are available.
    private let noImagesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No images"
        if #available(iOS 13, *) {
            lbl.textColor = .systemGray
        } else {
            lbl.textColor = .gray
        }
        lbl.font = UIFont.preferredFont(forTextStyle: .title3)
        lbl.textAlignment = .center
        lbl.sizeToFit()
        return lbl
    }()
    
    
    /// Initialize the photo library view controller with the plant being shown.
    init(plant: Plant) {
        self.plant = plant
        super.init(collectionViewLayout: UICollectionViewLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(PhotoLibraryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // Some styling of the view.
        if #available(iOS 13, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        
        // Hide the no images label when there are images.
        view.addSubview(noImagesLabel)
        noImagesLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        noImagesLabel.isHidden = images.count != 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoLibraryCollectionViewCell
        
        cell.setCellImageTo(images[indexPath.item])
        
        return cell
    }
    
}



extension PhotoLibraryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
