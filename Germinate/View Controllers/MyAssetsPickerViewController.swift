//
//  MyAssetsPickerViewController.swift
//  Germinate
//
//  Created by Joshua on 11/25/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import Photos

class MyAssetsPickerViewController: AssetsPickerViewController {

    let myPickerDelegate: AssetsPickerDelegate
    
    let plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
        self.myPickerDelegate = AssetsPickerDelegate(plant: plant)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        isShowLog = false
        pickerDelegate = myPickerDelegate
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        myPickerDelegate.assetsPickerDidCancel(controller: self)
    }
}
