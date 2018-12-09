//
//  Tax.swift
//  TASCShopping
//
//  Created by impadmin on 12/4/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This is a model class to hold information about taxes
public class Tax{
    
    public var taxName:String?
    public var taxPercentage = 0.0;
    
    public var taxPriceDisplayString:String{
        get{
            guard let name = self.taxName else{
               return ""
            }
             return name + "@" + self.taxPercentage.toPercentageDisplayString() 
        }
    }
    
}
