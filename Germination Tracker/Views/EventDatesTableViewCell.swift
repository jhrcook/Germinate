//
//  GerminationDatesTableViewCell.swift
//  Germination Tracker
//
//  Created by Joshua on 10/7/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

class EventDatesTableViewCell: UITableViewCell {

    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    let counterContainer = UIStackView()
    
    let numberLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    let subtractButton: UIButton = {
        let btn = UIButton(type: .contactAdd)
        if #available(iOS 13, *) {
            btn.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        }
        return btn
    }()
    let addButton: UIButton = {
        let btn = UIButton(type: .contactAdd)
        if #available(iOS 13, *) {
            btn.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        }
        return btn
    }()

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterContainer)
        
        counterContainer.addArrangedSubview(subtractButton)
        counterContainer.addArrangedSubview(numberLabel)
        counterContainer.addArrangedSubview(addButton)
        
        counterContainer.axis = .horizontal
        counterContainer.spacing = 10
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        counterContainer.snp.makeConstraints{ make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(15)
            make.trailing.equalTo(contentView).inset(20)
            make.centerY.equalTo(dateLabel)
        }
        
        numberLabel.snp.makeConstraints{ make in make.width.equalTo(20)}
    }
    
    
    func configureCell(forDate date: Date, withNumberOfGerminations numberOfGerminations: Int, withTag tag: Int) {
        dateLabel.text = dateFormatter.string(from: date)
        numberLabel.text = "\(numberOfGerminations)"
        
        dateLabel.tag = tag
        addButton.tag = tag
        subtractButton.tag = tag
    }

}

