//
//  ShoppinglistTableViewCell.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/20/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  purpose: configure the item cell to be shown in the shoplist table view

import UIKit
import CoreData

protocol shopListCellDelegate:NSObjectProtocol {
    func checkOutButttonclick()
}

class ShoppinglistTableViewCell: UITableViewCell {
    // Mark: Outlets
    @IBOutlet weak var shopListItemName: UILabel!
    @IBOutlet weak var shopListItemNumLabel: UILabel!
    @IBOutlet weak var shopListItemPrice: UILabel!
    @IBOutlet weak var shopListItemTotal: UILabel!
    @IBOutlet weak var shopListItemPic: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: shopListCellDelegate?
    
    // managed objectcontext
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    //mark variables
    var OrderMO:OrderMO?
    var sellingItemMO:SellingItemMO?
    
    //configure the shoplist cell to be used in the shoplist table view
    func configureCell(sellingItem: SellingItemMO){
        sellingItemMO = sellingItem
        self.shopListItemPic.image = UIImage(data:sellingItem.itemImage! as Data)
        self.shopListItemNumLabel.text = "\(sellingItem.sellingNumber)"
        self.shopListItemPrice.text = "\(sellingItem.sellingPrice)"
        self.shopListItemName.text = sellingItem.itemName
        self.shopListItemTotal.text = "\((sellingItem.sellingPrice) * Float(sellingItem.sellingNumber))"
        
        }

    
    
    // save shoplist item to the core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("shoppinglist Item saved to Core Data")
            } catch let error {
                
                print("Could not save Shoplist item to Core Data: \(error.localizedDescription)")
            }
            
        }
        
    }

    
    
    
    
    
    

}
