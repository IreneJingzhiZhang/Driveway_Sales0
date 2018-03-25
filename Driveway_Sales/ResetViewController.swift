//
//  ResetViewController.swift
//
//
//  Created by Jingzhi Zhang on 11/1/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//  Purpose: this viewcontroller uses core data to change user's password if his or her accessibility is identified.

import UIKit
import MessageUI
import CoreData

class ResetViewController: UIViewController, MFMailComposeViewControllerDelegate {
    //Markup: Outlets
    @IBOutlet weak var inputEmail: UITextField!

    @IBOutlet weak var InputCode: UITextField!
    @IBOutlet weak var setPwd: UITextField!
    @IBOutlet weak var ConPwd: UITextField!
    
    @IBOutlet weak var ConCodeBtn: UIButton!
    @IBOutlet weak var changePwdBtn: UIButton!
    var code: UInt32!
    
    //Markup: Actions
    
    @IBAction func SendCode(_ sender: UIButton) {
        //generate code 
        code = arc4random_uniform(10000)
        InputCode.isHidden = false
        ConCodeBtn.isHidden = false
        //valiadate the format of the email and make sure it is in the system
        if validateEmail(enteredEmail:inputEmail.text!){
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
            request.returnsObjectsAsFaults = false
            
            //use a loop to fetch email address data
            do{
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let results = try context.fetch(request)
                
                for item in results as! [NSManagedObject]{
                    //if the email address exists in the system
                    if (inputEmail.text == item.value(forKey: "email") as? String){
                        // Create a mail composer using the MFMailComposeViewController class
                        // and assign it as a delegate
                        let mailComposeVC = MFMailComposeViewController()
                        mailComposeVC.mailComposeDelegate = self
                        let toRecipents = [inputEmail.text]
                        let emailTitle = "JZ-EDirectory"
                        let messageBody = "Hello, this email is from Divvy Bikes's App by Jingzhi Zhang, Z1806811. The generated code to identify your account is \(code!)"
                        
                        mailComposeVC.setToRecipients(toRecipents as? [String])
                        mailComposeVC.setSubject(emailTitle)
                        mailComposeVC.setMessageBody(messageBody, isHTML: false)
                        
                        
                        // If MFMailComposer can send mail, then present the populated
                        // mail composer view controller.
                        if MFMailComposeViewController.canSendMail() {
                            self.present(mailComposeVC, animated: true, completion: nil)
                        }
                        else {
                            print("Cannot send an email!")
                        }
                        
                    }
                }//end the for loop
            }//end the do loop
            catch{
                print("Fetched Data Error!")
            }
        }
        else{
            displayMessage(userMessage: "Email doesn't exist!")
        }

    }
    
    // This is the MFMailComposerViewController delegate method.
    // When it finishes sending mail, dismiss the view controller.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func ConfirmCode(_ sender: UIButton) {
        //if the input code matches with the code sent to the email, show the folowing steps to change the password
        if InputCode.text == String(code){
            ConPwd.isHidden = false
            setPwd.isHidden = false
            changePwdBtn.isHidden = false
            print(code)
            //Check if input passwords match
            if(setPwd.text != ConPwd.text)
            {
                // Display an alert message
                displayMessage(userMessage: "Passwords do not match");
                return;
                
            }
            // if the password matches, save the new password of the email account in core data
            else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let newUser = NSEntityDescription.insertNewObject(forEntityName:"User", into: context)
                newUser.setValue(ConPwd.text,forKey:"password")
                
                //save the context if no error is catched
                do{
                    try context.save()
                    print("SAVED!")
                }
                catch{
                    print("ERROR!")
                }
                
                displayMessage(userMessage: "Successfully confirmed your identity.")
            }
           
        }
        else{
            displayMessage(userMessage: "The code doesn't match with the one we sent to you. Please input again")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InputCode.isHidden = true
        setPwd.isHidden = true
        ConPwd.isHidden = true
        ConCodeBtn.isHidden = true
        changePwdBtn.isHidden = true
        self.hideKeyboardWhenTappedAround()
        inputEmail.clearButtonMode = .always
        InputCode.clearButtonMode = .always
        setPwd.clearButtonMode = .always
        ConPwd.clearButtonMode = .always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //display note meessage
    @objc func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "System Message", message: userMessage, preferredStyle: .alert)
                
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
    
    // validate the format of the email
    @objc func validateEmail(enteredEmail:String) -> Bool {
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


