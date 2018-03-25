//
//  salesSummaryController.swift
//  Driveway
//
//  Created by Jingzhi Zhang on 2017/4/23.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: search item by item name and view its sold and unsold number

import UIKit
import CoreData

class salesSummaryController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //Outlets
    @IBOutlet weak var topSearBar: UISearchBar!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var OrderListTableView: UITableView!
    
    @IBOutlet weak var orterSoldSegment: UISegmentedControl!
    
    // initialize array for sold item and unsold item
    var isSoldArray = [SellingItemMO]()
    var unSoldArray = [SellingItemMO]()
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // original view
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate and data
        self.OrderListTableView.delegate = self
        self.OrderListTableView.dataSource = self
        // Do any additional setup after loading the view.
        setUpSearchBar()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

    }
    
    //set up search  bar
    fileprivate func setUpSearchBar() {
        //        self.topSearBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        self.topSearBar.showsScopeBar = true
        self.topSearBar.placeholder =  "Please input your stored item name"
        
        self.topSearBar.selectedScopeButtonIndex = 0
        
        self.topSearBar.delegate = self
    }
    
    // search text in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            //            imageItemArray = CoreDataManager.fetchObj()
            
            self.OrderListTableView.reloadData()
            return
        }
        searchSellingItem(itemName:searchText)  {
            (sellingItem) in
            if let sellingItems = sellingItem {
                
                for index in 0 ..< sellingItems.count {
                    var sellingItem:SellingItemMO = sellingItems[index]
                    
                    if sellingItem.itemQuantity > 0 && sellingItem.isSold > 0 {
                        isSoldArray.append(sellingItem)
                        unSoldArray.append(sellingItem)
                    } else if sellingItem.itemQuantity == 0 && sellingItem.isSold > 0{
                        isSoldArray.append(sellingItem)
                        
                    } else if sellingItem.itemQuantity > 0 && sellingItem.isSold == 0 {
                        unSoldArray.append(sellingItem)
                    }
                    
                    
                }
            }
        }
        OrderListTableView.reloadData()
    }
    
    //if value is changed, reload data
    @IBAction func valueChanged(_ sender: Any) {
        self.OrderListTableView.reloadData()
    }

    // using predicate and request to search the item from core data
    func searchSellingItem(itemName: String!, completion: ([SellingItemMO]?)->Void) {
        
        var results = [SellingItemMO]()
        let request: NSFetchRequest<SellingItemMO> = SellingItemMO.fetchRequest()
        
        let predicate = NSPredicate(format:"itemName contains[c] %@", itemName)

        request.predicate = predicate
        
        do {
            //remove the existing data and get new qualified data
            isSoldArray.removeAll()
            unSoldArray.removeAll()
            results = try managedObjectContext!.fetch(request)
            //            sellingItem = results
            
            completion(results)
            
        }catch {
            print("Could not fetch items from CoreData:\(error.localizedDescription)")
        }
    }
    
    // return the number of sold ot unsold items
    func numberOfSections(in tableView: UITableView) -> Int {
        if orterSoldSegment.selectedSegmentIndex == 0 {
            return isSoldArray.count
        } else {
            return unSoldArray.count
        }
    }
    
    // only one row in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // configure cell in the row
    let cellID = "summaryIdentify"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! salesSummaryCell
        if orterSoldSegment.selectedSegmentIndex == 0 {
            cell.configuresCell(sellingItem:isSoldArray[indexPath.section], ifSold: true)
        } else {
            cell.configuresCell(sellingItem:unSoldArray[indexPath.section], ifSold: false)
        }
        
        return cell
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
