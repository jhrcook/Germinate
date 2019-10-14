//
//  LibraryTableViewCell.swift
//  Germination Tracker
//
//  Created by Joshua on 10/13/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class LibraryTableViewCell: UITableViewCell {

    let containerView: UIView = {
        let v = UIView()
        if #available(iOS 13, *) {
            v.backgroundColor = .secondarySystemBackground
        }
        v.layer.cornerRadius = 8
        return v
    }()
    
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.preferredFont(forTextStyle: .title2)
        return tl
    }()
    
    let dateLabel: UILabel = {
        let dl = UILabel()
        dl.font = UIFont.preferredFont(forTextStyle: .body)
        return dl
    }()
    
    
    
    
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeZone = TimeZone.current
        return df
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellView()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            updateCellColor(forState: .selected)
        } else {
            updateCellColor(forState: .notselected)
        }
    }
    
    
    func configureCellFor(_ plant: Plant) {
        titleLabel.text = plant.name
        dateLabel.text = dateFormatter.string(from: plant.dateOfSeedSowing)
    }
    
    
    private func setupCellView() {
        
        self.textLabel?.isHidden = true
        self.detailTextLabel?.isHidden = true
        self.imageView?.isHidden = true
        
        addSubview(containerView)
        containerView.snp.makeConstraints{ make in
            make.top.equalTo(self).inset(5)
            make.leading.equalTo(self).inset(10)
            make.top.equalTo(self).inset(5)
            make.trailing.equalTo(self).inset(10)
            
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView).inset(10)
            make.leading.equalTo(containerView).inset(10)
            make.trailing.equalTo(containerView).inset(10)
        }
        titleLabel.sizeToFit()
        
        // TODO: add date label to view hierarchy
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            updateCellColor(forState: .selected)
        } else {
            updateCellColor(forState: .notselected)
        }
    }
    
    enum CellTappedState { case selected, notselected}
    private func updateCellColor(forState tappedState: CellTappedState) {
        
        var selectedColor: UIColor!
        var notselectedColor: UIColor!
        
        if #available(iOS 13, *) {
            selectedColor = .tertiarySystemBackground
            notselectedColor = .secondarySystemBackground
        } else {
            selectedColor = .gray
            notselectedColor = .white
        }
        
        switch tappedState {
        case .selected:
            containerView.backgroundColor = selectedColor
        case .notselected:
            containerView.backgroundColor = notselectedColor
        }
    }

}
