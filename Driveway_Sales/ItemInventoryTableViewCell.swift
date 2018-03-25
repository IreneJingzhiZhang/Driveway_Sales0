//
//  ItemInventoryTableViewCell.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: set up item inventory cell and show all of its information.

import UIKit
import CoreData

class ItemInventoryTableViewCell: UITableViewCell {

    //Mark: Outletes
    @IBOutlet weak var IIImageView: UIImageView!
    @IBOutlet weak var IIName: UITextField!
    @IBOutlet weak var IIQuantity: UITextField!
    @IBOutlet weak var IIDesc: UITextView!
    @IBOutlet weak var IICond: UITextField!
    @IBOutlet weak var IISuggPrice: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // set up item inventory cell
    func configureIICell(sellingItem: SellingItemMO){
        // self.IIName.text = "\(sellingItem.itemName)"
        // show information in the according area
        self.IIName.text = sellingItem.itemName
        //        sellingItem.itemQuantity
        self.IIQuantity.text = String(stringInterpolationSegment:sellingItem.itemQuantity)
        
        self.IIImageView.image = UIImage(data:sellingItem.itemImage! as Data)
        self.IIDesc.text = sellingItem.itemDesc
        self.IICond.text = sellingItem.itemCondition
        self.IISuggPrice.text = String(stringInterpolationSegment: sellingItem.suggestPrice)
        
    }

}
