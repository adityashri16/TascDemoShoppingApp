//
//  ReceiptViewController.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import UIKit

//This is a simple controller class to display the receipt calculated from the cart
class ReceiptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var receiptTable: UITableView!
    
    var receipt:Receipt?
    
    // MARK: -View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receipt"
        
        self.receipt = ReceiptService().calculateReceipt()
        
        self.receiptTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.receiptTable.reloadData()
        
    }
    
    // MARK: -Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.receipt?.items else {
            return 0
        }
        return items.count + 2 // adding two more rows to show total amount and total tax
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.receiptTable.dequeueReusableCell(withIdentifier: "cellIdentifier")else {
            return UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        }
        
        if let receiptObj = self.receipt{
            if let items = receiptObj.items{
                if(indexPath.row == items.count + 1){ // show total amount at last row
                     cell.textLabel?.text = "Total: " +  receiptObj.grandTotal.toPriceDisplayString()
                }
                else if (indexPath.row == items.count){ // show total sales tax for 2nd last row
                    cell.textLabel?.text = "Sales Tax: " + receiptObj.totalTaxes.toPriceDisplayString()
                }
                else{ //show receipt item
                    cell.textLabel?.numberOfLines = 3
                    cell.textLabel?.lineBreakMode = .byWordWrapping
                    cell.textLabel?.text = items[indexPath.row].itemName
                }
            }
        }
        
       return cell
    }
    


    
}
