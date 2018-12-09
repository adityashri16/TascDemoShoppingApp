//
//  ReceiptService.swift
//  TASCShopping
//
//  Created by impadmin on 12/8/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This service is to interact with receipt. It will create a receipt using the shared cart.
public class ReceiptService{

    //this method calculates receipts fron the existing cart and returns the object of receipt to be printed or persisted
    func calculateReceipt()->Receipt{
        
        let receipt = Receipt()
        
        var totalSalesTax = 0.0
        var grandTotal = 0.0
        var receiptItems:Array<ReceiptItem> = []
        
        //iterate cart and create items.
        // add total tax amount and price
        for cartItem in CartService.shared.getCart(){
            
            let reciptItem = ReceiptItem()
            reciptItem.itemName = cartItem.receiptEntryString
            reciptItem.quantity = cartItem.quantity
            reciptItem.productId = cartItem.product?.id ?? 0
            reciptItem.totalPrice = (100*cartItem.totalAmount).rounded()/100
            
            receiptItems.append(reciptItem)
            
            totalSalesTax += cartItem.totalTaxAmount
            
            grandTotal += cartItem.totalAmount
            
        }
        
        receipt.items = receiptItems
        //rounding to two decimal places as in the expected output. This could be as is and only be rounded up in presentation only too.
        receipt.grandTotal = (100*grandTotal).rounded()/100
        receipt.totalTaxes = (100*totalSalesTax).rounded()/100
        receipt.transactionId = Int.random(in: 0..<6) //random for demo purpose
        
        return receipt
        
    }
}
