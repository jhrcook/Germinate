//
//  EditNoteView.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class EditNoteView: UIView {
    
    var titleTextView: UITextView = {
        var textView = UITextView()
        textView.textAlignment = .left
        return textView
    }()
    
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    var detailTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        return textView
    }()
    
    
    func configureEditView(withNote note: SeedNote?) {
        
        titleTextView.text = note?.title ?? ""
        datePicker.date = note?.dateCreated ?? Date()
        detailTextView.text = note?.detail ?? ""
        
        addSubview(titleTextView)
        addSubview(datePicker)
        addSubview(detailTextView)
        
        titleTextView.snp.makeConstraints({ make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(self).inset(20)
            make.height.equalTo(60)
        })
        datePicker.snp.makeConstraints({ make in
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
            make.centerY.equalTo(self)
            make.height.equalTo(80)
        })
        detailTextView.snp.makeConstraints({ make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(20)
        })
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
