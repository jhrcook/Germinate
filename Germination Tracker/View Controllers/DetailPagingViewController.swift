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
    
    var currentScrollIndex = 0 {
        didSet {
            let titleAdditions = ["Info", "Notes"]
            title = "\(plant.name) - \(titleAdditions[currentScrollIndex])"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        currentScrollIndex = 0
        
        detailPagingView.navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
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
        currentScrollIndex = scrollView.contentOffset.x < 0.5 * 414.0 ? 0 : 1
    }
    
}
