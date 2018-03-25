//
//  SelectingItemTableViewCell.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/20/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import UIKit
import CoreData

protocol selectionImteCellDelegate:NSObjectProtocol {
    func thatButttonclick()
}



class SelectingItemTableViewCell: UITableViewCell, UITextFieldDelegate {
    // closure
    var changeSellingNumber:((_ sellingNumber:String?) -> Void)?
    var thatButtonClick:(()->())?
    var outNumberAlert:(()->Void)?
    
// delegate
    weak var delegate: selectionImteCellDelegate?
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var sellingItemMO:SellingItemMO?
    
    // mark: outlets
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!

    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBOutlet weak var quantityOnHand: UITextField!
    
    @IBOutlet weak var sellingNumber: UITextField!
    
    @IBOutlet weak var conditionTF: UITextField!
    
    @IBOutlet weak var suggestedPriceTF: UITextField!
    
    @IBOutlet weak var sellingPriceTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // configure the select item cell 
    // and update the selling price and number to sell if needed
    func configureCell(sellingItem: SellingItemMO){
        sellingItemMO = sellingItem
        self.itemImageView.image = UIImage(data:sellingItem.itemImage! as Data)
        self.itemImageView.isUserInteractionEnabled = false
        
        self.itemName.text = sellingItem.itemName
        self.descriptionTV.text = sellingItem.itemDesc
        self.quantityOnHand.text = "\(sellingItem.itemQuantity)"
        self.conditionTF.text = sellingItem.itemCondition
        self.sellingNumber.delegate = self
        self.suggestedPriceTF.text = "\(sellingItem.suggestPrice)"
        self.sellingNumber.text = "1"
        self.sellingPriceTF.text = "\(sellingItem.suggestPrice)"
        self.sellingPriceTF.delegate = self
        sellingNumber.clearButtonMode = .always
        sellingPriceTF.clearButtonMode = .always
    }
    
    //if the user has choosen the item they want to sell
    @IBAction func thatitButtonClick(_ sender: Any) {
        sellingItemMO?.sellingNumber = Int16(self.sellingNumber.text!)!
        sellingItemMO?.sellingPrice = Float(self.sellingPriceTF.text!)!
        if ((sellingItemMO?.itemQuantity)! >= (sellingItemMO?.sellingNumber)!){
            sellingItemMO?.itemQuantity -= (sellingItemMO?.sellingNumber)!
            saveToCoreData {
                
            }
            
            thatButtonClick!()
        }
        else {
            outNumberAlert!()
            

        }
        
        
    }
    
    // save to core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("Product saved to Core Data")
            } catch let error {
                
                print("Could not save Sales Season to Core Data: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
