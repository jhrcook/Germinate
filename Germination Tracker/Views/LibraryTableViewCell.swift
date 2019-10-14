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
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .title2)
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        return lbl
    }()
    
    let germinationInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .right
        return lbl
    }()
    
    /// The disclosure button that is the indicator of a standard `UITableViewCell`.
    /// This button may or may not be available depending on if there is a discolsure button available.
    var accessoryButton: UIButton?
    
    
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


    /// Set the values of a cell for a plant.
    /// - parameter plant: The plant to use for the cell.
    func configureCellFor(_ plant: Plant) {
        titleLabel.text = plant.name
        dateLabel.text = dateFormatter.string(from: plant.dateOfSeedSowing)
        germinationInfoLabel.text = "\(plant.germinationDatesManager.totalCount) / \(plant.numberOfSeedsSown)"
    }
    
    
    /// Set up the view of the cell.
    /// Needs only to be called once during initialization.
    private func setupCellView() {
        
        getAccessoryButton()
        
        self.textLabel?.isHidden = true
        self.detailTextLabel?.isHidden = true
        self.imageView?.isHidden = true
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self).inset(5)
            make.leading.equalTo(self).inset(10)
            make.bottom.equalTo(self).inset(5)
            make.trailing.equalTo(self).inset(10)
            
        }
                
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(10)
            make.bottom.equalTo(containerView.snp.centerY)
            make.leading.equalTo(containerView).inset(10)
            make.trailing.equalTo(containerView).inset(25)
        }
        titleLabel.sizeToFit()
        
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(containerView).offset(10)
            make.leading.equalTo(titleLabel)
        }
        dateLabel.sizeToFit()
        
        containerView.addSubview(germinationInfoLabel)
        germinationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.bottom.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).inset(20)
            make.trailing.equalTo(titleLabel)
        }
        
        if let button = accessoryButton {
            containerView.addSubview(button)
            containerView.snp.makeConstraints { make in
                make.trailing.equalTo(contentView).inset(8)
                make.centerY.equalTo(containerView)
            }
        }
    }
    
    
    /// Set the accessory button from standard `UITableViewCell` to `accessoryButton`.
    /// This method is called during set-up and is only needed once.
    private func getAccessoryButton() {
        // If already assigned, then return early
        if accessoryButton != nil { return }
        accessoryType = .disclosureIndicator
        accessoryButton = subviews.compactMap { $0 as? UIButton }.first
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
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            updateCellColor(forState: .selected)
        } else {
            updateCellColor(forState: .notselected)
        }
    }
    
    
    /// The state of a cell as either selected or not.
    enum CellTappedState { case selected, notselected}
    
    
    /// Set the table view cell background to the right color for whether it is tapped or not.
    /// - parameter tappedState: Whether the cell is being tapped or not.
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
