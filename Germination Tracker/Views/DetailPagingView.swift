//
//  DetailPagingView.swift
//  Germination Tracker
//
//  Created by Joshua on 9/21/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class DetailPagingView: UIView {
    
    var scrollView = UIScrollView()
    var informationView = InformationView()
    var notesView = NotesView()
    
    func setupView() {
        
        backgroundColor = .purple
        
        // set up the views
        setupScrollView()
        informationView.setupView()
        notesView.setupView()
        
        // set up view heirarchy
        self.addSubview(scrollView)
        scrollView.addSubview(informationView)
        scrollView.addSubview(notesView)
        
        // make constraints
        scrollView.snp.makeConstraints({ make in make.edges.equalTo(self) })
        informationView.snp.makeConstraints({ make in
            make.top.equalTo(scrollView)
            make.left.equalTo(scrollView)
            make.width.equalTo(self)
            make.bottom.equalTo(scrollView)
        })
        notesView.snp.makeConstraints({ make in
            make.top.equalTo(scrollView)
            make.left.equalTo(informationView.snp.right)
            make.width.equalTo(self)
            make.bottom.equalTo(scrollView)
        })
        
        scrollView.contentSize = CGSize(width: self.frame.width * 2.0, height: self.frame.height)
        
        print("frame size - x: \(frame.width), y: \(frame.height)")
        print("scroll view content size - x: \(scrollView.contentSize.width), y: \(scrollView.contentSize.height)")
    }
    
    
    func setupScrollView() {
        scrollView.backgroundColor = .clear
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
