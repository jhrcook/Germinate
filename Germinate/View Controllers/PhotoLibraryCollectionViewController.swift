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
//    var images = [UIImage]()
    
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
    
    /// The number of images in a row
    private let numberOfImagesPerRow: CGFloat = 4.0
    
    /// The spacing between images.
    private let spacingBetweenCells: CGFloat = 0.5
    
    /// The flow layout for the collection view.
    let flowLayout = UICollectionViewFlowLayout()
        
    /// Initialize the photo library view controller with the plant being shown.
    init(plant: Plant) {
        self.plant = plant
        super.init(collectionViewLayout: flowLayout)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(PhotoLibraryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Some styling of the view.
        if #available(iOS 13, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        loadPlantImages()
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadPlantImages()
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoLibraryCollectionViewCell
        
        if let image = plant.photosManager.imageAt(index: indexPath.item) {
            cell.setCellImageTo(image)
            cell.backgroundColor = .green
        }
        return cell
    }

    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are \(plant.photosManager.numberOfPhotos) photos.")
        return plant.photosManager.numberOfPhotos
    }
    
    /// Call this function is the photos may have changed.
    func plantPhotosMayHaveChanged() {
        loadPlantImages()
    }
    
    /// Load the images to show of the plants.
    private func loadPlantImages() {
        // Load images to be shown.
//        images.removeAll(keepingCapacity: true)
//        images = plant.photosManager.retrieveAllThumbnails()
        
        collectionView.reloadData()
        
        // Hide the no images label when there are images.
        view.addSubview(noImagesLabel)
        noImagesLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view).priority(.low)
        }
        noImagesLabel.isHidden = plant.photosManager.numberOfPhotos != 0
    }
    
}


extension PhotoLibraryCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / numberOfImagesPerRow - (spacingBetweenCells * numberOfImagesPerRow)
        return CGSize(width: width, height: width)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
}
