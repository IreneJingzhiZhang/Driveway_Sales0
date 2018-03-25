//
//  OrderTableViewCell.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/10/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
// Purpose: show created order in the cell

import UIKit
import CoreData

class OrderTableViewCell: UITableViewCell {
    
// Mark: Outlets
    @IBOutlet weak var orderNumTField: UITextField!
    @IBOutlet weak var orderDateTfield: UITextField!
    @IBOutlet weak var orderTimeTField: UITextField!
    @IBOutlet weak var orderCustomerNameTF: UITextField!
    @IBOutlet weak var orderPhoneNumTF: UITextField!
    @IBOutlet weak var orderEmailAddrTF: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    // configure the cell to be used in the Order Tableview controller
    func configureCell(order: OrderMO){
        
        //show the input information in the cell
        self.orderNumTField.text = order.orderNum

        self.orderDateTfield.text = order.orderDate
        self.orderTimeTField.text = order.orderTime
//
//        let timeDate = DateFormatter()
//        timeDate.dateStyle = .short
//        self.orderTimeTField.text = timeDate.string(from: order.orderTime! as Date)
        
        self.orderCustomerNameTF.text = order.orderCusName
        self.orderPhoneNumTF.text = order.orderCusPhoneNum
        self.orderEmailAddrTF.text = order.orderCusEMail
    }

}
