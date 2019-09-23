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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func setupCell() {
        
        backgroundColor = .white
        
//        frame = layer.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        layer.borderColor = FlatWatermelon().cgColor
//        layer.borderWidth = 1
//        layer.cornerRadius = 8
//        layer.masksToBounds = true
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(detailLabel)
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(self).offset(4)
            make.leading.equalTo(self).inset(4)
            make.trailing.equalTo(self).inset(4)
        })
        dateLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).inset(8)
            make.trailing.equalTo(self).inset(4)
        })
        detailLabel.snp.makeConstraints({ make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).inset(8)
            make.trailing.equalTo(self).inset(4)
            make.bottom.equalTo(self).inset(4)
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
