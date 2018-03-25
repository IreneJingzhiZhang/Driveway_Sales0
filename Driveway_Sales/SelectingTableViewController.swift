//
//  SelectingTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/20/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import UIKit
import CoreData

class SelectingTableViewController: UITableViewController,UISearchBarDelegate {
    // mark: variables
    var sellingItem = [SellingItemMO]()
    var sNumber: String?
    var sPrice: String?
    var shopplingList:(([SellingItemMO]) -> Void)?
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpSearchBar()
        
        let alert = UIAlertController(title: "Would you like to scan item?", message: "scan barcode to get item checked out", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes, I would to scan barcode", style: .default){ (action) -> Void in
            let checkScannerViewController = self.storyboard?.instantiateViewController(withIdentifier: "checkScannerViewController") as! checkScannerViewController
        self.navigationController!.pushViewController(checkScannerViewController, animated: true)
        })
        alert.addAction(UIAlertAction(title: "No, I prefer to search name", style: .default){ (action) -> Void in
        })
        present(alert, animated: true, completion: nil)
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

    }

    // set up search bar
    fileprivate func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        
        searchBar.showsScopeBar = true
        searchBar.placeholder =  "Please input the item name"
//        searchBar.scopeButtonTitles = ["name","by","year"]
        searchBar.selectedScopeButtonIndex = 0
        
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }
    
    // if the text in the search bar has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
//            imageItemArray = CoreDataManager.fetchObj()
            
            self.tableView.reloadData()
            return
        }
        searchSellingItem(itemName:searchText)  {
            (sellingItem) in
            if let sellingItems = sellingItem {
                self.sellingItem = sellingItems
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    // using predicate and request to search item if the text matches
    func searchSellingItem(itemName: String!, completion: ([SellingItemMO]?)->Void) {
        
        var results = [SellingItemMO]()
        let request: NSFetchRequest<SellingItemMO> = SellingItemMO.fetchRequest()
        
        let predicate = NSPredicate(format:"itemName contains[c] %@", itemName)
        
        
        
        
//        '\(itemName)'
        request.predicate = predicate
        
        do {
            sellingItem.removeAll()
            results = try managedObjectContext!.fetch(request)
//            sellingItem = results
            
            completion(results)
            
        }catch {
            print("Could not fetch Seasons from CoreData:\(error.localizedDescription)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sellingItem.count
    }
   
    // only one row in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }
    
    // set height for header and footer
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    // get the cell information from the selectitemtable view cell
    let cellId = "selectItemCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectingItemTableViewCell

        // Configure the cell...
        cell.configureCell(sellingItem: self.sellingItem[indexPath.section])
        // use and accept closure
//        cell.changeSellingNumber = { (sellingNumber) in
//                self.sNumber = sellingNumber
//        }
        
    //choose item
        cell.thatButtonClick = {
          self.shopplingList!([self.sellingItem[indexPath.section]])
            self.navigationController?.popViewController(animated: true)
        }
        
        // if the quantity on hand doesnt have enough to sell, show alert
        cell.outNumberAlert = {
            let alertController = UIAlertController(title: "OOPS", message: "You cannot sell more than you have.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        return cell
    }


}
