//
//  ProductDetail.swift
//  TASCShopping
//
//  Created by impadmin on 12/6/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This class holds details for a product like taxes applicable.
//More information like description, reviews, ratings etc. can be added based on requirements.
public class ProductDetail{
    public var product:Product? = nil
    public var taxes:Array<Tax>? = nil
    
    //Just a method to help UI in displaying the applicable taxes on this product
    public var taxesString:String {
        get {
            var taxNames:Array<String> = []
            if let taxList = self.taxes{
                for tax in taxList{
                    taxNames.append(tax.taxPriceDisplayString)
                }
            }
            return taxNames.joined(separator: ", ")
        }
    }
}
