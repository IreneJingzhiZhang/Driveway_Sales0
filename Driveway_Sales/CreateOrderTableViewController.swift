//
//  CreateOrderTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/10/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: create and save an order (basic info like date and time, order id, etc. )

import UIKit
import CoreData

class CreateOrderTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    // Mark: Outlets
    @IBOutlet weak var orderNumTF: UITextField!
    @IBOutlet weak var orderDataTF: UITextField!
    @IBOutlet weak var orderTimeTF: UITextField!
    @IBOutlet weak var orderCusNameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    //After input the basic order information and clicked to next button, save the order info
    @IBAction func nextBarClicked(_ sender: UIBarButtonItem) {
        saveCreateNewOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

        //        saveCreateNewOrder()
        // show the information input
        //order num
        let orderNumGen = arc4random_uniform(10000)
        orderNumTF.text = String(orderNumGen)
        
        //order time
        let timeformatter = DateFormatter()
        timeformatter.timeStyle = .short
        
        orderTimeTF.text = timeformatter.string(from: NSDate() as Date)
//        timeDate = timeformatter.date(from: orderTimeTF.text!)! as NSDate
        
        //order date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        orderDataTF.text = dateFormatter.string(from: NSDate() as Date)
        
//         dayDate = timeformatter.date(from: orderDataTF.text!)! as NSDate
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // save the basic information of the new order
    func saveCreateNewOrder(){
        // if the missing information is required, show aert
        if orderNumTF.text!.isEmpty || orderDataTF.text!.isEmpty || orderTimeTF.text!.isEmpty {
            //set up alert
            let alertController = UIAlertController(title: "OOPS", message: "You need to give all the informations required to save this Order", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            
            // Here we save to core data
            
            if let moc = managedObjectContext {
                let order = OrderMO(context: moc)
                order.orderNum = orderNumTF.text!
                
//                let orderDatestring = orderDataTF.text!
//                let dateFormatter = DateFormatter()
//                let date = dateFormatter.date(from:orderDatestring)
                
//                order.orderDate = date as NSDate?
//                
//                let orderTimeString = orderTimeTF.text!
//                let dateFormatter2 = DateFormatter()
//                let time = dateFormatter2.date(from: orderTimeString)
//                order.orderTime = time as NSDate?
                
                order.orderDate = orderDataTF.text!
                order.orderTime = orderTimeTF.text!
                
                //optional information
                if (orderCusNameTF.text?.isEmpty)! {
                    
                } else {
                    order.orderCusName = orderCusNameTF.text!
                }
                if (phoneNumTF.text?.isEmpty)! {
                    
                } else {
                    order.orderCusPhoneNum = phoneNumTF.text!
                }
                if (emailTF.text?.isEmpty)! {
                    
                } else {
                    order.orderCusEMail = emailTF.text!
                }
                
                saveToCoreData() {
                    // when save, jump to shopping list
                    let addItem = self.storyboard?.instantiateViewController(withIdentifier: "Shopping List") as! ShoppingListTableViewController
                    addItem.orderNum = order.orderNum
                    self.navigationController?.pushViewController(addItem, animated: true)
                }
                
                
            }
        }
        
    }
    
    
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("Created Order saved to CoreData")
            } catch let error {
                print("Could not save created order to CoreData: \(error.localizedDescription)")
            }
            
        }
        
    }
    
}
