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
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .left
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
        
        self.backgroundColor = .white
        layer.borderColor = FlatWatermelon().cgColor
        layer.borderWidth = 4
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(detailLabel)
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(self)
            make.leading.equalTo(self).inset(4)
            make.trailing.equalTo(self).inset(4)
            make.height.equalTo(40)
        })
        dateLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(self).inset(4)
            make.trailing.equalTo(self).inset(4)
            make.height.equalTo(40)
        })
        detailLabel.snp.makeConstraints({ make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(self).inset(4)
            make.trailing.equalTo(self).inset(4)
            make.height.equalTo(40)
            make.bottom.equalTo(self)
        })
        
    }
    
}
