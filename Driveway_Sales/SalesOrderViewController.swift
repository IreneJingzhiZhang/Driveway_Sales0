//
//  SalesOrderViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/9/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//  Purpose: show the total sales order based on the information got fron the shoplist

import UIKit
import MessageUI
import CoreData

class SalesOrderViewController: UIViewController, UINavigationControllerDelegate,CardIOPaymentViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet weak var ScanCredit: UIView!
    //Mark: Variables
    var discount:Float = 1.0
    var salesAmount:Float = 0.0
    var paySumAmount:Float = 0.0
    
    @IBOutlet weak var resultLabel: UILabel!
    //Mark: Outlets
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountSlidder: UISlider!
    @IBOutlet weak var finalSubLabel: UILabel!
    @IBOutlet weak var payTypeLabel: UILabel!
    @IBOutlet weak var payTypeSeg: UISegmentedControl!
    @IBOutlet weak var payAmount: UITextField!
    @IBOutlet weak var changesLabel: UILabel!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var PAL: UILabel!
    @IBOutlet weak var chL: UILabel!
    @IBOutlet weak var SalesOrder: UINavigationItem!
    
    // Actions
    
    @IBAction func payTypesegController(_ sender: UISegmentedControl) {
        switch payTypeSeg.selectedSegmentIndex{
        case 0:
            //the case of cash: show the amount the customer paid and the changes to return
            payTypeLabel.text = "Cash"
            chL.isHidden = false
            PAL.isHidden = false
            payAmount.isHidden = false
            ScanCredit.isHidden = true
            //reload()
        
        //the case of credit card. 
        //to do: scan credit card to pay
        case 1:
            chL.isHidden = true
            PAL.isHidden = true
            payAmount.isHidden = true
            changesLabel.isHidden = true
            payTypeLabel.text = "Credit Card"
            ScanCredit.isHidden = false
            //capture creadit card
            
        default:
            break
        }
    }
    
    // when clicked the pay button, show the changes
    @IBAction func PayBtnClicked(_ sender: UIButton) {
        changesLabel.isHidden = false
        if payAmount.text?.isEmpty == false{
            paySumAmount = Float(payAmount.text!)!
            changesLabel.text = "\(paySumAmount - salesAmount * discount * 0.01)"
        }
    }
    
    
    // send an e-mail
    @IBAction func emailBtnClicked(_ sender: UIButton) {
        // Create a mail composer using the MFMailComposeViewController class
        // and assign it as a delegate
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        if emailTextFiled.text?.isEmpty == false {
        let toRecipents = [emailTextFiled.text!]
        let emailTitle = "Sales Order Total"
        let messageBody = "\(salesAmount * discount * 0.01)"
        
        mailComposeVC.setToRecipients(toRecipents)
        mailComposeVC.setSubject(emailTitle)
        mailComposeVC.setMessageBody(messageBody, isHTML: false)
        }
        
        // If MFMailComposer can send mail, then present the populated
        // mail composer view controller.
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        
    }
    
    // This is the MFMailComposerViewController delegate method.
    // When it finishes sending mail, dismiss the view controller.
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    //set up a text message controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //send a message
    @IBAction func txtBtnClicked(_ sender: AnyObject) {
        if MFMessageComposeViewController.canSendText(){
            
            let controller = MFMessageComposeViewController()
            //controller.body = "This is the receipt of you order. 
            controller.body = self.phoneTextField.text!
            controller.recipients = [self.phoneTextField.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {print("Couldn't send an message!")}
    }
    
    //using a slidder to choose the discount rate
    @IBAction func discountSlidderAction(_ sender: UISlider) {
        subtotalLabel.text = "\(salesAmount)"
        discount = ((round(sender.value)))
        discountLabel.text = "\(100 - discount)" + "%"
        finalSubLabel.text = "\(salesAmount * discount / 100)"
    }
    
    // show the original page
    override func viewDidLoad() {
        super.viewDidLoad()
        payTypeLabel.text = "Cash"
        subtotalLabel.text = "\(salesAmount)"
        discountLabel.text = "0%"
        finalSubLabel.text = "\(salesAmount * discount)"
        // Do any additional setup after loading the view.
        
        //go back to the root controller
        setBackBarButton()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()
        
        CardIOUtilities.preload()
        
        ScanCredit.isHidden = true
        
    }
    

    
    func setBackBarButton(){
        
        let leftBtn:UIBarButtonItem=UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.plain, target: self, action:#selector(popToRootViewController))
        
        self.SalesOrder.leftBarButtonItem = leftBtn;
    }
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated:true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanCard(_ sender: UIButton) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        resultLabel.text = "user canceled"
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            resultLabel.text = str as String
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
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
