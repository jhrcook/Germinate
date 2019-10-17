//
//  GerminationDatesTableViewCell.swift
//  Germination Tracker
//
//  Created by Joshua on 10/7/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit

/**
 A custom table view cell that shows a date and a counter.
 
 The date is shown on the left. The right side shows "-" and "+" buttons
 surrounding a number.
 */
class EventDatesTableViewCell: UITableViewCell {
    
    /// The label for the date.
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    /// The container for the label with the number and the two buttons.
    let counterContainer = UIStackView()
    
    /// Label with the number surrounded by the minus and plus buttons.
    let numberLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// The button with a "-" symbol.
    let subtractButton: UIButton = {
        let btn = UIButton(type: .contactAdd)
        if #available(iOS 13, *) {
            btn.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        }
        return btn
    }()
    
    /// The button with a "+" symbol.
    let addButton: UIButton = {
        let btn = UIButton(type: .contactAdd)
        if #available(iOS 13, *) {
            btn.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        }
        return btn
    }()

    /// A `DateFormatter` object with the format "yyyy-MM-dd" in the current time zone.
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeZone = .current
        return df
    }()
    
    
    // Set up custom view after initialize.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    
    // Set up custom view after initialize.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    
    /// Set up the cell view.
    /// - description: This mainly just builds the view hierarchy and adds constraints. This method
    /// need only be run once when the cell is created. It is automatically called upon initialization.
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
    
    
    /// Configure the information shown by the cell.
    /// - parameter date: The date to be shown on the cell.
    /// - parameter number: The number to display.
    /// - parameter tag: The tag for the labels and dates.
    func configureCell(forDate date: Date, withNumber number: Int, withTag tag: Int) {
        dateLabel.text = dateFormatter.string(from: date)
        numberLabel.text = "\(number)"
        
        dateLabel.tag = tag
        numberLabel.tag = tag
        addButton.tag = tag
        subtractButton.tag = tag
    }

}

