//
//  barcodeItemViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 12/7/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import UIKit
import CoreData

class barcodeItemViewController: UIViewController, UITextFieldDelegate {

    var sellingItem = [SellingItemMO]()
    var barcodeString: String!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var Desc: UITextField!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var condition: UITextField!
    
    @IBOutlet weak var price: UITextField!
    
    
    
    
    @IBAction func AddItem(_ sender: UIButton) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var managedObjectContext: NSManagedObjectContext? {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        
        let itemFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SellingItem")
        itemFetch.predicate = NSPredicate(format: "barcode == %@", barcodeString)
        do{
            let fetchedItem = try managedObjectContext?.fetch(itemFetch) as! [SellingItemMO]
            
            if let item = fetchedItem.first {
                itemName.text = item.itemName
                itemImageView.image = UIImage(data:item.itemImage! as Data,scale:1.0)
                Desc.text = item.itemDesc
                Quantity.text = "\(item.itemQuantity)"
                condition.text = item.itemCondition
                price.text = String(item.suggestPrice)
            }
        }
        catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
