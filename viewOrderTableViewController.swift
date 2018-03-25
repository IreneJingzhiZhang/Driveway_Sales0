//
//  viewOrderTableViewController.swift
//  Driveway
//
//  Created by Jingzhi Zhang on 4/23/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  when the user clicked the cell in the ordertableview controller, it goes to view the specific purchased items in this page.

import UIKit
import CoreData

class viewOrderTableViewController: UITableViewController {
    
    //variables
    var orderNum: String?
    var orderItem = [SellingItemMO]()
    
    //managedObjectContext
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

        retrieveSeasons()
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
        return orderItem.count
    }
    
    // show the cell in
    let cellId = "View Order List Table View Cell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for: indexPath) as! viewOrderListTableViewCell
        cell.configureCell(sellingItem:orderItem[indexPath.row])
        return cell
    }
    
    // retrieve and reload the data of items.
    func retrieveSeasons(){
        fetchSellingSeasonsFromCoreData {(sellingseasons) in
            if let sellingseasons = sellingseasons {
                self.orderItem = sellingseasons
                
                self.tableView.reloadData()
            }
        }
    }
    
    //search and fetch the items under the same ordernum from core data.
    func fetchSellingSeasonsFromCoreData(completion: ([SellingItemMO]?)->Void){
        var results = [SellingItemMO]()
        
        let request: NSFetchRequest<SellingItemMO> = SellingItemMO.fetchRequest()

        // connect the string
        let formatString:String! = "orderNum = " + orderNum!
        
        let predicate = NSPredicate(format:formatString)
        
        request.predicate = predicate
        do {
            results = try managedObjectContext!.fetch(request)
            //  or
            //            results = try managedObjectContext!.fetch(request) as! [SellingSectionMO]
            completion(results)
        }catch {
            print("Could not fetch Seasons from Core Data:\(error.localizedDescription)")
        }
        
    }
    
        
}
