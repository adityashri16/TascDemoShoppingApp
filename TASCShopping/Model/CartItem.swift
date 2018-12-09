//
//  CartItem.swift
//  TASCShopping
//
//  Created by impadmin on 12/4/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This is a model class to hold cart item information
public class CartItem {
    
    public var product:Product? = nil
    public var quantity = 0;
    public var taxes:Array<Tax>? = nil
    
    //calculates the total base price for the product based on the quantity
    public var totalBasePrice:Double {
        get {
            
            guard let prod = self.product else {
                return 0.0
            }
            
            let basePrice = prod.price * Double(quantity)
            
            return basePrice
        }
    }
    
    //Calculates total tax amount on the cart item by applying all applicable taxes on this item
    public var totalTaxAmount:Double {
        get {
            
            let basePrice = self.totalBasePrice
            //If base price is 0 then total amount will anyways be 0
            if (basePrice <= 0.0) {
                return 0.0
            }
            
            //Calculate toal tax percent by iterating on tax list
            var taxAmount = 0.0
            if let taxList = self.taxes {
                
                for tax:Tax in taxList {
                    
                    var tempTaxAmount = (basePrice * tax.taxPercentage/100)
                    //Rounding up tax amount to the nearest multiple of 0.05
                    tempTaxAmount = ceil(tempTaxAmount / 0.05) * 0.05
                    taxAmount += tempTaxAmount
                }
            }
            return taxAmount
        }
    }
    
    //Calculates total payable amount for this cart item includig taxes
    public var totalAmount:Double
    {
        get{
        
            let basePrice = self.totalBasePrice
            
            //If base price is 0 then total amount will anyways be 0
            if (basePrice <= 0.0) {
                return 0.0
            }
            //Calculate total tax amount
            let totalTax = self.totalTaxAmount
            //Total amount of item will be base price + total tax amount on the product
            let amount = basePrice + totalTax
        
            return amount;
        }
    }
    
    //Returns the string representation of the cart item to be shown in the receipt
    public var receiptEntryString:String{
        
        get{
            var stringForCartItem = ""
            
            if(self.quantity > 0){
                stringForCartItem += String(self.quantity)
            }
            
            if let product = self.product{
                if(product.isImported){
                    stringForCartItem += " Imported"
                }
                stringForCartItem += " " + (product.name ?? "")
            }
            
            stringForCartItem += " : " + self.totalAmount.toPriceDisplayString()
            
            return stringForCartItem
            
        }
        
    }
}
