//
//  ReceiptItem.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This class represents each item in the receipt that is purchased.
public class ReceiptItem{
    public var itemName:String? //name of item
    public var totalPrice = 0.0//amount to be paid with taxes
    public var quantity = 0 // quantity
    public var productId = 0 // id of the product purchased
    
}
