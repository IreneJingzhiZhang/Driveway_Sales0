//
//  ItemInventoryTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: get year and season infomation from SalesSeason and item information from ItemInventoryTableViewCell.



import UIKit
import CoreData

class ItemInventoryTableViewController: UITableViewController {
    var keyYear:NSNumber?
    var keySeason:NSString?
    
    var IIArray = [SellingItemMO]()

    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    @IBAction func showAddItem(_ sender: Any) {
        let addItem = self.storyboard?.instantiateViewController(withIdentifier: "Add New Item") as! AddItemTableViewController
        addItem.keyYear = keyYear
        addItem.keySeason = keySeason! as String
        self.navigationController?.pushViewController(addItem, animated: true)
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
        retrieveII()
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
        return IIArray.count
    }

    let cellId = "IICell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemInventoryTableViewCell

        // Configure the cell...
        cell.configureIICell(sellingItem:IIArray[indexPath.row])
        return cell
        
    }
 
    func retrieveII(){
        fetchIIfromCoreData {(sellingItems) in
            if let sellingItems = sellingItems {
                self.IIArray = sellingItems
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchIIfromCoreData(completion:([SellingItemMO]?)->Void){
     
        
        
        var results = [SellingItemMO]()
        let request: NSFetchRequest<SellingItemMO> = SellingItemMO.fetchRequest()
        //  let request = NSFetchRequest<NSManagedObject>(entityName: "SellingSection")
        // inputed year
        let currentYear: NSNumber = keyYear!
        // inputed season
        let currentSeasom: NSString = keySeason!
        //  query requirement
        let predicate = NSPredicate(format:"year = \(currentYear)  AND season = '\(currentSeasom)'")
        
        request.predicate = predicate
        
        do {
            
            results = try managedObjectContext!.fetch(request)
            // or
            // results = try managedObjectContext!.fetch(request) as! [SellingSectionMO]
            completion(results)
            
        }catch {
            print("Could not fetch Seasons from CoreData:\(error.localizedDescription)")
        }
        
    }

}
