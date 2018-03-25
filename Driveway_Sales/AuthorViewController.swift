//
//  AuthorViewController.swift
//  ZhangCoreData
//
//  Created by Jingzhi Zhang on 3/24/17.
//  Copyright © 2017 NIU Computer Science. All rights reserved.
//  Purpose: show author infomation fron the html view

import UIKit

class AuthorViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Create a path to the index.html "data" file bundled under the "html" folder
        let path = Bundle.main.path(forResource: "/html/index", ofType: "html")!
        let data: NSData = NSData(contentsOfFile:path)!
        let html = NSString(data: data as Data, encoding:String.Encoding.utf8.rawValue)
        
        // Load the webView outlet with the content of the index.html file
        webView.loadHTMLString(html as! String, baseURL: Bundle.main.bundleURL)
        
        //set the blank between the "name" and navigation bar to not opaque and clear color  and it will be white. you can just set the IB in About Author view
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
