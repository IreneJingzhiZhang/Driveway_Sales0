//
//  viewOrderListTableViewCell.swift
//  Driveway
//
//  Created by Jingzhi Zhang on 4/23/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
// Purpose: set up the cell in the viewOrderTableView

import UIKit

class viewOrderListTableViewCell: UITableViewCell {
    
    //Mark: Outlets
    @IBOutlet weak var viewOrderImage: UIImageView!
    @IBOutlet weak var viewOrderItemName: UILabel!
    @IBOutlet weak var viewOrderSub: UILabel!
    
    
    var viewOrderList = [OrderMO]()
    
    //configure the cell of the items in the order to be shown in the viewOrder Table view
    func configureCell(sellingItem: SellingItemMO){
        self.viewOrderImage.image = UIImage(data:sellingItem.itemImage! as Data)
        self.viewOrderItemName.text = sellingItem.itemName
        self.viewOrderSub.text = "\((sellingItem.sellingPrice) * Float(sellingItem.sellingNumber))"

    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
