//
//  Receipt.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This class holds the information for the receipt like items purchased, total taxes, total amount etc.
public class Receipt{
    
    public var items:Array<ReceiptItem>? //items purchased
    public var totalTaxes = 0.0;//total taxes
    public var grandTotal = 0.0;//amount to be paid
    public var transactionId = 0; //based on business logic
    
}
