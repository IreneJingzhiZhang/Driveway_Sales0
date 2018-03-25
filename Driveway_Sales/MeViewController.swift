//
//  MeViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/13/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: register, log in and out and all kinds of sharing. About app link

import UIKit
import Social

class MeViewController: UIViewController {
    
    // Actions
    // share with facebook
    @IBAction func fbbuttonClicked(_ sender:UIButton)
    {
        let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        post?.setInitialText("Hi facebook friends! I'm using Driveway_Sales! Come check it out with me!")
        present(post!,animated: true, completion: nil)
        
    }
    
    // share with twitter
    @IBAction func ttbuttonClicked(_ sender:UIButton)
    {
        let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        post?.setInitialText("Hello Twitter friends! I'm using Driveway_Sales! Come check it out with me!")
        present(post!,animated: true, completion: nil)
        
    }
    
    // share with sina ====== to be continued
    @IBAction func snbuttonClicked(_ sender:UIButton)
    {
        let post = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        post?.setInitialText("Hello Sina friends! I'm using Driveway_Sales! Come check it out with me!")
        present(post!,animated: true, completion: nil)
    }
    
    // share with text
    @IBAction func swbuttonClicked(_ sender:UIButton)
    {
        let text = "I'd like to share this App with you."
        let textToShare = [text]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view// so the app won't crash on ipad.
        //exclude some activity types from the list(optional)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.postToFacebook]
        
        //present the view Controller
        self.present(activityVC, animated: true,completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()

    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


