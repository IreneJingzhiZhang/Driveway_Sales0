//
//  salesSummaryCell.swift
//  Driveway
//
//  Created by Jingzhi Zhang on 2017/4/23.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: configure the cell shown in the sales summary view controller


import UIKit

class salesSummaryCell: UITableViewCell {
    
    @IBOutlet weak var sSImage: UIImageView!
    
    @IBOutlet weak var sSName: UILabel!
    
    @IBOutlet weak var sSNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // configure the cell shown in the sales summary view controller 
    // vary by if it is sold or not 
    func configuresCell(sellingItem: SellingItemMO, ifSold: Bool/*, sum: String*/){
        self.sSImage.image = UIImage(data:sellingItem.itemImage! as Data)
        self.sSName.text = sellingItem.itemName
        if ifSold {
            self.sSNumber.text = "\(sellingItem.isSold)"
        } else {
            self.sSNumber.text = "\(sellingItem.itemQuantity)"
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
