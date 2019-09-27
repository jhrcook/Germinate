//
//  InformationViewController.swift
//  Germination Tracker
//
//  Created by Joshua on 9/26/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    weak var plant: Plant!
    weak var plantsManager: PlantsArrayManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .purple
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
