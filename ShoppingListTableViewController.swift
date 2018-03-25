//
//  ShoppingListTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/20/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
// purpose: show total price and manage items

import UIKit
import CoreData


class ShoppingListTableViewController: UITableViewController {
    var sellingItem = [SellingItemMO]()
    var orderList = [OrderMO]()
    var orderNum: String?
    var subtotal = Float(0)
    
    
    @IBOutlet weak var TotalAmountLabel: UILabel!
//  because they are all on the view, just hide the view
    //because it is at the bottom of the table , so  pass the data to tableFooterView.
    @IBOutlet weak var footVIew: UIView!
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    @IBOutlet weak var checkOutButtonClicked: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pass data to table view
        self.tableView.tableFooterView = footVIew;
        //  
        // hide at first. use the condition to see if it meet them and them when there is data
        // todo : seal it to a function and call.
        
        if (sellingItem.count > 0){
            footVIew.isHidden = false
            CalSumAmount()
            TotalAmountLabel.text = "\(subtotal)"
        } else {
            footVIew.isHidden = true
//            TotalAmountLabel.isHidden = true
        }
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

        
    }
    

     //calculate the total amount of the purchased items
    func CalSumAmount(){
        subtotal = 0.0
        for index in 0..<sellingItem.count
        {
            let calItems:SellingItemMO? = self.sellingItem[index]
            subtotal += (calItems?.sellingPrice )! * Float((calItems?.sellingNumber)!)
        }
    }

    // after clicking the check out button, change the item sold or not status and save to core data.
    @IBAction func checkOutButtonClicked(_ sender: UIButton) {
        for index in 0..<sellingItem.count
        {
            let tempItems:SellingItemMO? = self.sellingItem[index]
            tempItems?.isSold += (tempItems?.sellingNumber)!
            tempItems?.orderNum = orderNum
            saveToCoreData(){}
        }
        let checkOutSummary = TotalAmountLabel.text
        performSegue(withIdentifier: "checkOutSummary", sender: checkOutSummary)
        
    }
    
    ////send the total price to the sales summary page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        for index in 0..<sellingItem.count
        {
            let tempItems:SellingItemMO? = self.sellingItem[index]
            tempItems?.isSold += (tempItems?.sellingNumber)!
            tempItems?.orderNum = orderNum
            if segue.identifier == "checkOutSummary" {
                if let destination = segue.destination as? SalesOrderViewController {
                    destination.salesAmount = self.subtotal
                }
            }

            saveToCoreData(){
                if segue.identifier == "checkOutSummary" {
                    if let destination = segue.destination as? SalesOrderViewController {
                        destination.salesAmount = self.subtotal
                    }
                }
            }
        }
//        let checkOutSummary = TotalAmountLabel.text
        

    }
    
    
    @IBAction func pushSelectingItem(_ sender: Any) {
        let itemInventory = self.storyboard?.instantiateViewController(withIdentifier: "Selecting Item") as! SelectingTableViewController
        itemInventory.shopplingList = {
            (itemList) in
            //SoldTO.append(itemList)
            self.sellingItem += itemList
            //self.sellingArray?.append(itemList)
            
            //control hide or show
            if (self.sellingItem.count > 0){
                self.footVIew.isHidden = false
                self.CalSumAmount()
                self.TotalAmountLabel.text = "\(self.subtotal)"
            } else {
                self.footVIew.isHidden = true
                //            TotalAmountLabel.isHidden = true
            }
            
            
                       self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(itemInventory, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sellingItem.count
    }

    
    let cellId = "SLCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ShoppinglistTableViewCell
        
        cell.configureCell(sellingItem:sellingItem[indexPath.row])
        
        //TO control Cell  see the data in the cell?
        if (sellingItem.count > 0){
//            checkOutButtonClicked.isHidden = false
//            TotalAmountLabel.isHidden = false
            CalSumAmount()
//            TotalAmountLabel.text = "\(subtotal)"
        }
        else {
//            checkOutButtonClicked.isHidden = true
//            TotalAmountLabel.isHidden = true
        }


        return cell
    }
    // edit row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    // edit slide to left delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // commit the delete 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let tempSellingItem:SellingItemMO? = self.sellingItem[indexPath.row]
            tempSellingItem?.itemQuantity += (tempSellingItem?.sellingNumber)!
            self.sellingItem.remove(at: indexPath.row)
            saveToCoreData(){}
            
            self.tableView.reloadData()
            
        }
    }
    

    // save to ore data
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

    // delete the item in the shoplist
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
        

    }
    
   
}
