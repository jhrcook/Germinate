//
//  InformationViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/26/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class InformationViewController: UIViewController {

    var plant: Plant
    var plantsManager: PlantsArrayManager!
    
    var informationView: InformationView!
    
    
    init(plant: Plant) {
        self.plant = plant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        informationView = InformationView(frame: view.frame)
        view.addSubview(informationView)
        informationView.snp.makeConstraints({ make in make.edges.equalTo(view) })
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
