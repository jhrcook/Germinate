//
//  LibraryTableViewCell.swift
//  Germination Tracker
//
//  Created by Joshua on 10/13/19.
//  Copyright © 2019 Joshua Cook. All rights reserved.
//

import UIKit
import SnapKit


/// The custom table view cell for the `LibraryViewController` table view.
class LibraryTableViewCell: UITableViewCell {

    /// If the cells are grouped or not.
    var cellsAreGrouped = false
    
    /// The title label.
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        return lbl
    }()
    
    /// The date label that shows the date the plant was sown.
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        return lbl
    }()
    
    /// The label with some germination information. It is currently set to display the fraction of seeds that
    /// have successfully germinated.
    let germinationInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .right
        return lbl
    }()
    
    /// Image for archived plants.
    let archiveLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Archived"
        lbl.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        if #available(iOS 13, *) {
            lbl.textColor = .secondaryLabel
        } else {
            lbl.textColor = .gray
        }
        
        return lbl
    }()
    
    /// The disclosure button that is the indicator of a standard `UITableViewCell`.
    /// This button may or may not be available depending on if there is a discolsure button available.
    var accessoryButton: UIButton?
    
    /// A `DateFormatter` object with the format "yyyy-MM-dd" in the current time zone.
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeZone = TimeZone.current
        return df
    }()
    
    
    // Initialization calls custom set up.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    
    // Initialization calls custom set up.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellView()
    }


    /// Set the values of a cell for a plant.
    /// - parameter plant: The plant to use for the cell.
    func configureCellFor(_ plant: Plant) {
        titleLabel.text = plant.name
        dateLabel.text = dateFormatter.string(from: plant.dateOfSeedSowing)
        germinationInfoLabel.text = "\(plant.germinationDatesManager.totalCount) / \(plant.numberOfSeedsSown)"
        
        // Set information view.
        archiveLabel.isHidden = plant.isActive
        
    }
    
    
    /// Set up the view of the cell.
    /// Needs only to be called once during initialization.
    private func setupCellView() {
        
        getAccessoryButton()
        
        self.textLabel?.isHidden = true
        self.detailTextLabel?.isHidden = true
        self.imageView?.isHidden = true

        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(germinationInfoLabel)
        addSubview(archiveLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self.snp.centerY).offset(10)
            make.leading.equalTo(self).inset(25)
            make.trailing.equalTo(self).inset(25)
        }
        
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
        
        
        if let button = accessoryButton {
            addSubview(button)
            button.snp.makeConstraints { make in
                make.trailing.equalTo(self).inset(8)
                make.centerY.equalTo(self)
            }
        }
        
        germinationInfoLabel.snp.makeConstraints { make in
            make.trailing.equalTo(accessoryButton!.snp.leading).offset(-25)
            make.centerY.equalTo(self)
        }
        
        archiveLabel.snp.makeConstraints { make in
            make.trailing.equalTo(germinationInfoLabel)
            make.bottom.equalTo(self).inset(5)
        }
        archiveLabel.sizeToFit()

        
    }
    
    
    /// Set the accessory button from standard `UITableViewCell` to `accessoryButton`.
    /// This method is called during set-up and is only needed once.
    private func getAccessoryButton() {
        // If already assigned, then return early
        if accessoryButton != nil { return }
        accessoryType = .disclosureIndicator
        accessoryButton = subviews.compactMap { $0 as? UIButton }.first
    }

}
