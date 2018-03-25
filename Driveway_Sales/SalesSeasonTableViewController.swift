//
//  SalesSeasonTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: set up a table view for showing the existing year and season section

import UIKit
import CoreData

class SalesSeasonTableViewController: UITableViewController {
    
    // an array for selling section in the core data
    var seasonArray = [SellingSectionMO]()

    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        return seasonArray.count
    }
    //=========================== control the Section's header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    //=========================== control the Section's Footer height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    //show the information fron the salesSeasonTableViewCell
    let cellId = "seasonCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SalesSeasonTableViewCell
        
        // Configure the cell...
        
        cell.configureSSCell(sellingseason:seasonArray[indexPath.row])
        return cell
    }
    
    // click Cell to jump to ItemInventory page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // it is similar with the lining (segue). since it cannot jump to the page twice, we cannot use it.
        // performSegue(withIdentifier: "displaySection", sender: self)
        
        
        // Item Inventory is the ID of Storyboard. see the class in StoryBoard  Item Inventory
        let itemInventory = self.storyboard?.instantiateViewController(withIdentifier: "Item Inventory") as! ItemInventoryTableViewController
        let selling:SellingSectionMO = seasonArray[indexPath.row]
        //  To do: passing data between controllers (without relationship in core data, it is trivial. To be researched. )
        itemInventory.keyYear = selling.year
        itemInventory.keySeason = selling.seasom! as NSString
        self.navigationController?.pushViewController(itemInventory, animated: true)
        //  using xib is simpler than below
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let newVC = storyboard.instantiateViewController(withIdentifier: "Item Inventory") as! ItemInventoryTableViewController
        //        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // put the selling section (with things like year and season and others in the array to be chosen)
    func retrieveSeasons(){
        fetchSellingSeasonsFromCoreData {(sellingseasons) in
            if let sellingseasons = sellingseasons {
                self.seasonArray = sellingseasons
                
                self.tableView.reloadData()
            }
        }
    }
    
    //fetch data from year and seasons from core data
    func fetchSellingSeasonsFromCoreData(completion: ([SellingSectionMO]?)->Void){
        var results = [SellingSectionMO]()
        
        let request: NSFetchRequest<SellingSectionMO> = SellingSectionMO.fetchRequest()
        //or
        //          let request = NSFetchRequest<NSManagedObject>(entityName: "SellingSection")
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
