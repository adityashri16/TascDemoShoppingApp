//
//  TaxService.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
/*This service class should be used to interact with the taxes.
 The operations performed can be done on server in the real app.*/
public class TaxService{
    
    enum Taxes {
        case basicSalesTax
        case importDuty
    }
    
    //Categories to be exluded from taxation. This can be codes also instead of name.
    var exemptedCategories = ["Popcorn","Candy","Coffee"]
    
    //This can be done on server, we are just simulating a behavior on how tax are calculated for a product
    func getTaxesForProduct(product:Product)->([Tax]?){
        var taxes:[Tax] = []
        
        if let category = product.category{
            //Apply basic tax if not in exempted category
            if(!exemptedCategories.contains(category)){
                let salesTax = getTax(taxType: .basicSalesTax)
                taxes.append(salesTax)
            }
        }
        
        if(product.isImported){
            //Apply import duty if item is imported
            let importTax = getTax(taxType: .importDuty)
            taxes.append(importTax)
        }
        
        return taxes
        
    }
    
    //Get tax object for a tax type
    private func getTax(taxType:Taxes)->(Tax){
        let tax = Tax()
        switch taxType {
        case .importDuty:
            tax.taxName = "Import Tax"
            tax.taxPercentage = 5.00
            break
        case .basicSalesTax:
            tax.taxName = "Sales Tax"
            tax.taxPercentage = 10.00
        }
        
        return tax
    }
    
    
    
    
    
}
