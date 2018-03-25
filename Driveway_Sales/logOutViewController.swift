//
//  logOutViewController.swift
//
//
//  Created by Jingzhi Zhang on 11/1/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//  Purpose: this viewcontroller uses core data to display logged-in user's account information


import CoreData
import UIKit

class logOutViewController: UIViewController {

    @IBOutlet weak var userWelcome: UILabel!
    var userEmail: String = ""
    
    @IBOutlet weak var email_TextField: UITextField!
    @IBOutlet weak var name_TextField: UITextField!
    @IBOutlet weak var addr_TextField: UITextField!
    @IBOutlet weak var city_TextField: UITextField!
    @IBOutlet weak var state_TextField: UITextField!
    @IBOutlet weak var zip_TextField: UITextField!
    @IBOutlet weak var country_TextField: UITextField!
    
    @IBAction func LogOut(_ sender: UIButton) {
//        let ViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//
//        self.present(ViewController, animated: true, completion: nil)
        performSegueToReturnBack()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email_TextField.text = userEmail
        userWelcome.text = "Welcome! You've successfully logged in!"
        
        //Fetch data request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        request.returnsObjectsAsFaults = false
        
        
        //use a loop to fetch all the data
        do{
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let results = try context.fetch(request)
            
            for item in results as! [NSManagedObject]{
                if (userEmail == item.value(forKey: "email") as? String) {
                    name_TextField.text = (item.value(forKey: "first") as? String)! + " " + (item.value(forKey: "last") as? String)!
                    addr_TextField.text = item.value(forKey: "addr") as? String
                    city_TextField.text = item.value(forKey: "city") as? String
                    state_TextField.text = item.value(forKey: "state") as? String
                    zip_TextField.text = item.value(forKey: "zip") as? String
                    country_TextField.text = item.value(forKey: "country") as? String
                    
                    
                }
            }//end the for loop
        }//end the do loop
        catch{
            print("Fetched Data Error!")
        }

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

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
