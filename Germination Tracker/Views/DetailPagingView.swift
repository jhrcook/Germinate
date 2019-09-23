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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    init(frame: CGRect, navigationBarHeight: CGFloat) {
        print("frame - x: \(frame.width), y: \(frame.height)")
        print("nav bar height: \(navigationBarHeight)")
        
        let adjustedHeight = frame.height - navigationBarHeight
        let adjustedFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: adjustedHeight))
        super.init(frame: adjustedFrame)
        self.navigationBarHeight = navigationBarHeight
        
        setupView()
        
        print("adjusted frame - x: \(adjustedFrame.width), y: \(adjustedFrame.height)")
        print("self.frame - x: \(self.frame.width), y: \(self.frame.height)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        print("view frame - x: \(frame.width), y: \(frame.height)")
        
        // set up the views
        setupScrollView()
        informationView.setupView(withFrame: frame)
        notesView.setupView(withFrame: CGRect(origin: CGPoint(x: frame.width, y: 0), size: frame.size))
        
        // set up view heirarchy
        self.addSubview(scrollView)
        scrollView.addSubview(informationView)
        scrollView.addSubview(notesView)
        
        // make constraints
        scrollView.snp.makeConstraints({ make in make.edges.equalTo(self) })
        scrollView.contentSize = CGSize(width: frame.width * 2.0, height: frame.height)
        
        
    }
    
    
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isDirectionalLockEnabled = true
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
