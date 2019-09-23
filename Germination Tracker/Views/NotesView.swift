//
//  NotesView.swift
//  Germination Tracker
//
//  Created by Joshua on 9/21/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class NotesView: UIView {

    let textView = UITextView()
    
    struct NotesViewPalette {
        let lightOrange = UIColor(red: 255/255, green: 205/255, blue: 135/255, alpha: 1.0)
        let orange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        let darkOrange = UIColor(red: 181/255, green: 106/255, blue: 0/255, alpha: 1.0)
    }
    let notesViewPal = NotesViewPalette()
    
    func setupView() {
        
        self.addSubview(textView)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 2
        textView.layer.borderColor = notesViewPal.orange.cgColor
        textView.textColor = notesViewPal.darkOrange
        textView.snp.makeConstraints({ make in
            make.top.equalTo(self).inset(10)
            make.leading.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(10)
            make.bottom.equalTo(self).inset(10)
        })
        
    }
    
    
    func setupView(withFrame newFrame: CGRect) {
        setupView()
        frame = newFrame
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
