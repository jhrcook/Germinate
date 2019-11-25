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

    let myPickerDelegate = AssetsPickerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        isShowLog = false
        pickerDelegate = myPickerDelegate
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        myPickerDelegate.assetsPickerDidCancel(controller: self)
    }
}
