//
//  NoteTableViewCell.swift
//  Germination Tracker
//
//  Created by Joshua on 9/23/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

class NoteTableViewCell: UITableViewCell {

    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.backgroundColor = FlatWatermelon()
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.textAlignment = .center
        lbl.sizeToFit()
        lbl.layer.cornerRadius = 0
        lbl.layer.shadowOffset = CGSize(width: 3, height: 3)
        lbl.layer.shadowColor = UIColor.black.cgColor
        lbl.layer.shadowOpacity = 0.3
        return lbl
    }()
    
    var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = FlatWatermelonDark()
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        lbl.textAlignment = .right
        lbl.sizeToFit()
        return lbl
    }()
    
    var detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .left
        lbl.sizeToFit()
        return lbl
    }()
    
    var cellStackView: UIStackView {
        let sv = UIStackView()
        sv.distribution = .equalSpacing
        sv.axis = .vertical
        sv.spacing = 5
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return sv
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func setupCell() {
        
//        self.addSubview(cellStackView)
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(dateLabel)
        cellStackView.addArrangedSubview(detailLabel)
        
        cellStackView.snp.makeConstraints({ make in
            make.edges.equalTo(contentView)
        })
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(cellStackView)
            make.leading.equalTo(cellStackView)
            make.trailing.equalTo(cellStackView)
        })
        dateLabel.snp.makeConstraints({ make in
            make.leading.equalTo(cellStackView)
            make.trailing.equalTo(cellStackView)
        })
        detailLabel.snp.makeConstraints({ make in
            make.leading.equalTo(cellStackView)
            make.trailing.equalTo(cellStackView)
            make.bottom.equalTo(cellStackView)
        })
        
    }
    
    
    func configureCell(forNote note: SeedNote) {
        titleLabel.text = note.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let text = dateFormatter.string(from: note.dateCreated)
        dateLabel.text = text
        
        detailLabel.text = note.detail
    }
    
}
