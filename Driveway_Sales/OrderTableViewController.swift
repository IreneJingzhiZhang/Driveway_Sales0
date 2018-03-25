//
//  OrderTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/9/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: show all the create basic order informayion in cells

import UIKit
import CoreData

class OrderTableViewController: UITableViewController {
    
    //a variable of order array like the order class to hold data
    var orderArray = [OrderMO]()
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveOrders()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    // number of section is equal to th count of orderArray
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return orderArray.count
    }
    
    // the number of rows in section is one
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // each row is from the the order table view cell
    let cellId = "orderCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderTableViewCell
        
        // Configure the cell...
        cell.configureCell(order: self.orderArray[indexPath.section])
        return cell
    }
    
    // when click the cell in the order list, the specific items it contained will be shown in the view order
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewOrder = self.storyboard?.instantiateViewController(withIdentifier: "viewOrderStoryBoard") as! viewOrderTableViewController
        let orderMO = orderArray[indexPath.section]
        viewOrder.orderNum = orderMO.orderNum
        
        self.navigationController?.pushViewController(viewOrder, animated: true)
        
    }
    
    // retrieve and reload the table view to be updated
    func retrieveOrders(){
        fetchOrdersFromCoreData { (orders) in
            if let orders = orders {
                self.orderArray = orders
                self.tableView.reloadData()
            }
        }
    }
    
    // fetch order from core data
    func fetchOrdersFromCoreData(completion: ([OrderMO]?)->Void){
        var results = [OrderMO]()
        let request: NSFetchRequest<OrderMO> = OrderMO.fetchRequest()
        do {
            results = try  managedObjectContext!.fetch(request)
            completion(results)
        }catch {
            print("Could not fetch Products from CoreData:\(error.localizedDescription)")
        }
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
