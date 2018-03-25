//
//  GenerateViewController.swift
//  testBarcode
//
//  Created by Jingzhi Zhang on 11/12/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.



import UIKit
import MessageUI
import CoreData

class GenerateViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myEmailTF: UITextField!
    @IBOutlet weak var myItemNameLabel: UILabel!
    
    var itemName:String = ""
    var emailImage:UIImage!
    
    typealias closureBlock = (String) -> Void
    var postValueBlock: closureBlock?
    
    @IBAction func sendBarcode(_ sender: UIButton) {
        if postValueBlock != nil {
            postValueBlock!(itemName)
        }
        
        // If MFMailComposer can send mail, then present the populated
        // mail composer view controller.
        // Create a mail composer using the MFMailComposeViewController class
        // and assign it as a delegate
        if (!(myEmailTF.text?.isEmpty)!) {//if email address is empty
            // Two mathod to show the picture of barcode. (1)in the content (2)as attachment
            let selectAlert = UIAlertController(title:"email mode", message:"please choice email mode", preferredStyle:.alert)
            selectAlert.addAction(UIAlertAction(title:"add picture in content", style: .default) {(action) -> Void in
                self.imageInMessage()
            })
            selectAlert.addAction(UIAlertAction(title:"add picture in attachment", style: .default) {(action) -> Void in
                self.imageInAppendix()
            })
            present(selectAlert, animated: true, completion: nil)
        } else {
            let tipAlert = UIAlertController(title: "Tips", message: "please input your email address!", preferredStyle: .alert)
            tipAlert.addAction(UIAlertAction(title: "Continue", style: .default){ (action) -> Void in
            })
            present(tipAlert, animated: true, completion: nil)
        }
    }
    
    
    
    func imageInAppendix(){
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        let toRecipents = [myEmailTF.text]
        let emailTitle = "JZ-EDirectory"
        let messageBody = "Hello, this email is sent from the JZ-DrivewaySales App by Jingzhi Zhang, Z1806811. A generated barcode for item \(itemName) is as attatched."
        
        
        emailImage = myImageView.image!
        print(emailImage)
        
        let imageData = UIImagePNGRepresentation(emailImage)
        if MFMailComposeViewController.canSendMail() {
            mailComposeVC.setToRecipients(toRecipents as? [String])
            mailComposeVC.setSubject(emailTitle)
            mailComposeVC.setMessageBody(messageBody, isHTML: false)
            mailComposeVC.addAttachmentData(imageData!, mimeType: "image/png", fileName: "image.png")
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        else {
            print("Cannot send an email!")
        }
    }
    
    
    func imageInMessage() {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        let toRecipents = [myEmailTF.text]
        let emailTitle = "JZ-EDirectory"
        let messageBody = "Hello, this email is sent from the JZ-DrivewaySales App by Jingzhi Zhang, Z1806811. A generated barcode for item \(itemName) is as attatched."
        
        emailImage = myImageView.image!
        print(emailImage)
        
        let imageData = UIImagePNGRepresentation(emailImage)
        let imageBase64String = imageData?.base64EncodedString()
        let imageSource:String = "data:image/png;base64,"+imageBase64String!
        let emailBody:String = messageBody + "<img src ="+imageSource+"/>"
        if MFMailComposeViewController.canSendMail() {
            mailComposeVC.setToRecipients(toRecipents as? [String])
            mailComposeVC.setSubject(emailTitle)
            mailComposeVC.setMessageBody(emailBody, isHTML: true)
            mailComposeVC.addAttachmentData(imageData!, mimeType: "image/png", fileName: "image.png")
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        else {
            print("Cannot send an email!")
        }
    }
    // This is the MFMailComposerViewController delegate method.
    // When it finishes sending mail, dismiss the view controller.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // generate barcode and display it on imageview
        myItemNameLabel.text = itemName
        myItemNameLabel.textAlignment = NSTextAlignment.center
        let data = itemName.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        //scale to improve the resolution of the barcode
        let transform = CGAffineTransform(scaleX: 10,y: 10)
        let transformImage = filter!.outputImage!.applying(transform)
        
        //        myImageView.image = UIImage(ciImage: (transformImage))
        // 这里不能直接用CIImage 因为格式的问题转化会为空或者有其他的方式转化 
        // convert to CGImage first then use CGImage to convert to Data
        //
        let ciContext:CIContext = CIContext.init();
        let cgImageRef:CGImage = ciContext .createCGImage(transformImage, from: transformImage.extent)!;
        myImageView.image = UIImage(cgImage:(cgImageRef));
        
        
        //method two: in swift 4
        //let img = UIImage(ciImage:filter.outputImage!.transformed(by: transform))
        
        self.hideKeyboardWhenTappedAround()
        
        // Pass bacode string to ViewController
        let AddItemTableViewController = storyboard?.instantiateViewController(withIdentifier: "Add New Item") as! AddItemTableViewController
        AddItemTableViewController.barcodeString = itemName
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
