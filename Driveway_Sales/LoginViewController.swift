//
//  LoginViewController.swift
//  
//
//  Created by Jingzhi Zhang on 11/1/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//Purpose: This viewcontroller uses core data to fetch matched email account with password to help users to login.

import UIKit
import CoreData

class LoginViewController: UIViewController {
    // Markup: Outlets
    @IBOutlet weak var logEmail: UITextField!
    @IBOutlet weak var logPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboard controll
        self.hideKeyboardWhenTappedAround()
        // show clear button mode in textfield
        logEmail.clearButtonMode = .always
        logPwd.clearButtonMode = .always
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logEmail.text = ""
        logPwd.text = ""
    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        // Read values from text fields
        let userEmail = logEmail.text
        let userPassword = logPwd.text
        
        // Check if required fields are not empty
        if (userEmail?.isEmpty)! || (userPassword?.isEmpty)!
        {
            // Display alert message here
            
            displayMessage(userMessage: "All fields are required")
            
            return
        }
            
        else{
            if validateEmail(enteredEmail:userEmail!){
                //Fetch data request
                let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
                request.returnsObjectsAsFaults = false
                
                
                //use a loop to fetch all the data
                do{
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let results = try context.fetch(request)
                    
                        for item in results as! [NSManagedObject]{
                            if (logEmail.text == item.value(forKey: "email") as? String) && (logPwd.text == item.value(forKey: "password") as? String){
                                
                                let logOutViewController = storyboard?.instantiateViewController(withIdentifier: "logOutViewController") as! logOutViewController
                                logOutViewController.userEmail = self.logEmail.text!
                                self.logEmail.text = ""
                                self.present(logOutViewController, animated: true, completion: nil)
                            }
                        }//end the for loop
                }//end the do loop
                catch{
                    print("Fetched Data Error!")
                }
                //wrong password or email account information
                displayMessage(userMessage: "Account Info doesn't match.")
            }
            else{
                // the email format doesn't match the requirement
                displayMessage(userMessage: "Wrong format for email")
            }
        }
        
    }
    
    // display alert message
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    // validate the input email format
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
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


