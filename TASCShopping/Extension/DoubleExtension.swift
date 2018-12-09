//
//  DoubleExtension.swift
//  TASCShopping
//
//  Created by impadmin on 12/8/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This extension adds some UI helper methods to represent the double inr equired string format.
extension Double {
    public func toPriceDisplayString() -> String {
        
        return String(format: "$%.2f", self)
        
    }
    
    public func toPercentageDisplayString() -> String {
        
        return String(format: "%.2f", self) + "%"
        
    }
}
