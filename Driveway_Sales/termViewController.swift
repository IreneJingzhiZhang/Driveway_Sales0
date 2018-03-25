//
//  termViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 11/26/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//

import UIKit

class termViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "termsAccepted")
        
        performSegue(withIdentifier: "homeView", sender: sender)
    }
    
    // refuse button clicked
    
    
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
