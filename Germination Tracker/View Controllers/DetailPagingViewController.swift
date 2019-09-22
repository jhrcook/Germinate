//
//  DetailViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/21/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class DetailPagingViewController: UIViewController {

    var plant: Plant!
    var plantsManager: PlantsArrayManager!
    
    @IBOutlet var detailPagingView: DetailPagingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = plant.name
        detailPagingView.setupView()
        
        detailPagingView.scrollView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}


extension DetailPagingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("content offset - x: \(Int(scrollView.contentOffset.x)), y: \(Int(scrollView.contentOffset.y))")
    }
    
}
