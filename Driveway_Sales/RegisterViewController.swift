//
//  RegisterViewController.swift
//  
//
//  Created by Jingzhi Zhang on 11/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//  Purpose: this view controller uses core data to store newly registered user's account information

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    //markup: Outlets
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var newConPwd: UITextField!
    @IBOutlet weak var newFName: UITextField!
    @IBOutlet weak var newLName: UITextField!
    @IBOutlet weak var newAddr: UITextField!
    @IBOutlet weak var newCity: UITextField!
    @IBOutlet weak var newState: UITextField!
    @IBOutlet weak var newZip: UITextField!
    @IBOutlet weak var newCountry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newEmail.clearButtonMode = .always
        newConPwd.clearButtonMode = .always
        newPwd.clearButtonMode = .always
        newFName.clearButtonMode = .always
        newLName.clearButtonMode = .always
        newAddr.clearButtonMode = .always
        newCity.clearButtonMode = .always
        newState.clearButtonMode = .always
        newZip.clearButtonMode = .always
        newCountry.clearButtonMode = .always
        self.hideKeyboardWhenTappedAround()
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when pressed the signup button
    @IBAction func SignUp(_ sender: UIButton) {
        // markup: variables
        let userEmail = newEmail.text;
        let userPassword = newPwd.text;
        let userRepeatPassword = newConPwd.text;
        let userFName = newFName.text
        let userLName = newLName.text
        let userAddr = newAddr.text
        let userCity = newCity.text
        let userState = newState.text
        let userZip = newZip.text
        let userCountry = newCountry.text
        
        // Check for empty fields
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userRepeatPassword?.isEmpty)! || (userFName?.isEmpty)! || (userLName?.isEmpty)! || (userAddr?.isEmpty)! || (userCity?.isEmpty)! || (userState?.isEmpty)! || (userCountry?.isEmpty)! || (userZip?.isEmpty)!)
        {
            
            // Display alert message
            
            displayMessage(userMessage: "All fields are required");
            
            return;
        }
        
        //Check if passwords match
        if(userPassword != userRepeatPassword)
        {
            // Display an alert message
            displayMessage(userMessage: "Passwords do not match");
            return;
            
        }
        else{
            // validate the email format first
            if validateEmail(enteredEmail:userEmail!){
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                //store all input information in core data
                let newUser = NSEntityDescription.insertNewObject(forEntityName:"User", into: context)
                newUser.setValue(userEmail,forKey:"email")
                newUser.setValue(userPassword,forKey:"password")
                newUser.setValue(userFName,forKey:"first")
                newUser.setValue(userLName,forKey:"last")
                newUser.setValue(userAddr,forKey:"addr")
                newUser.setValue(userCity,forKey:"city")
                newUser.setValue(userState,forKey:"state")
                newUser.setValue(userZip,forKey:"zip")
                newUser.setValue(userCountry,forKey:"country")
                
                //save the context if no error is catched
                do{
                    try context.save()
                    print("SAVED!")
                }
                catch{
                    print("ERROR!")
                }
                // the user has successfully registered
                displayMessage(userMessage: "Successfully Registered.")
                
            }
            else{
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
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    //validate the input email format
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
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
