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
    
    var navigationBarHeight: CGFloat = 0.0
    
    func setupView() {
        // set up the views
        setupScrollView()
        informationView.setupView(withFrame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        notesView.setupView(withFrame: CGRect(origin: CGPoint(x: frame.width, y: 0), size: frame.size))
        
        // set up view heirarchy
        self.addSubview(scrollView)
        scrollView.addSubview(informationView)
        scrollView.addSubview(notesView)
        
        // make constraints
        scrollView.frame.size = self.frame.size
        scrollView.snp.makeConstraints({ make in make.edges.equalTo(self) })
        scrollView.contentSize = CGSize(width: self.frame.width * 2.0, height: self.frame.height - navigationBarHeight)
    }
    
    
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isPagingEnabled = true
        
        scrollView.frame = frame
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
