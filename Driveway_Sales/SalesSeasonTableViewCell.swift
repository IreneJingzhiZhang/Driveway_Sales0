//
//  SalesSeasonTableViewCell.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: set up a SalesSeasonTableViewCell to be used in the table view

import UIKit
import CoreData

class SalesSeasonTableViewCell: UITableViewCell {
    
    // Mark: Outlets
    @IBOutlet weak var salesYear: UITextField!
    @IBOutlet weak var salesSeason: UITextField!
    @IBOutlet weak var salesCurrency: UITextField!
    @IBOutlet weak var salesPayType: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // an function to be uesd in SalesSeason Tableview controller to show information the tableview cell
    func configureSSCell(sellingseason: SellingSectionMO){
        
        self.salesYear.text = "\(sellingseason.year)"
        self.salesSeason.text = sellingseason.seasom
        self.salesPayType.text = sellingseason.payType
        self.salesCurrency.text = sellingseason.currency
    }

}
