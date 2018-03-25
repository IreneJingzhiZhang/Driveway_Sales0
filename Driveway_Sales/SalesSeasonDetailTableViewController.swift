//
//  SalesSeasonDetailTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: add a salesSection and pass data to the salesSeasonTableViewController

import UIKit
import CoreData

//extension SellingSectionMO {
//    @nonobjc public class func fechRequest() -> NSFetchRequest<SellingSectionMO> {
//        return NSFetchRequest <SellingSectionMO>(entityName: "SellingSection")
//    }
//}

class SalesSeasonDetailTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    // Mark: Outlets
    @IBOutlet weak var enterYear: UITextField!
    
    @IBOutlet weak var enterSeason: UITextField!
    
    @IBOutlet weak var enterCurrency: UITextField!
    
    @IBOutlet weak var enterPayType: UITextField!
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSaveBarButton()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

    }
    
    // set up a save button
    func setSaveBarButton(){
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target:self, action:#selector(SalesSeasonDetailTableViewController.saveSales))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    // save the information input
    func saveSales(){
        if enterYear.text!.isEmpty || enterSeason.text!.isEmpty || enterPayType.text!.isEmpty || enterCurrency.text!.isEmpty {
            // show alert when the required information is missing
            let alertController = UIAlertController(title: "OOPS", message: "You need to enter all the required information to save this sales season.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            // Here we save
            
            if let moc = self.managedObjectContext {
                //  save the data. First go to the database to query if this sales section already exists
                searchCoreData { (sellingseasons) in
                    if (sellingseasons?.count)! > 0 { // when there is a selling section matching with the year and season
                        let alertController = UIAlertController(title: "OOPS", message: "This season in the year has already ", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // else store in CoreData
                        //                        let sellingseason = SellingSectionMO(context: moc)
                        // attributes in entities
                        let sellingseason = NSEntityDescription.insertNewObject(forEntityName: "SellingSection", into: self.managedObjectContext!) as! SellingSectionMO
                        // let sellingseason = NSManagedObject(entity: entity,
                        // insertInto: moc)
                        
                        sellingseason.setValue(Int16(enterYear.text!) as NSNumber?, forKey: "year")
                        sellingseason.setValue(enterSeason.text!, forKey: "seasom")
                        sellingseason.setValue(enterPayType.text!, forKey: "payType")
                        sellingseason.setValue(enterCurrency.text!, forKey: "currency")
                        
                        // save data
                        saveToCoreData() {
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                    }
                }
                           }
            
        }
    }
    //    }
    
    // search and get data from the specific year and season from the core data
    func searchCoreData(completion: ([SellingSectionMO]?)->Void){
        var results = [SellingSectionMO]()
        let request: NSFetchRequest<SellingSectionMO> = SellingSectionMO.fetchRequest()
        //         let request = NSFetchRequest<NSManagedObject>(entityName: "SellingSection")
        // inputed year
        let currentYear: NSNumber = (Int16(enterYear.text!) as NSNumber?)!
        // inputed season
        let currentSeasom: NSString = enterSeason.text! as NSString
        //  query requirement
        let predicate = NSPredicate(format:"year = \(currentYear)  AND seasom = '\(currentSeasom)'")
        
        request.predicate = predicate
        
        do {
            //
            results = try managedObjectContext!.fetch(request)
            // or
            //             results = try managedObjectContext!.fetch(request) as! [SellingSectionMO]
            completion(results)
            
        }catch {
            print("Could not fetch Seasons from CoreData:\(error.localizedDescription)")
        }
        
    }
    
    // save to core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            
            do {
                try self.managedObjectContext?.save()
                completion()
                print("Season Section saved to Core Data")
            } catch let error {
                
                print("Could not save Sales Season to Core Data: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
}
