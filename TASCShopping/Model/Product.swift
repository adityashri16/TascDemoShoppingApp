//
//  Product.swift
//  TASCShopping
//  Created by impadmin on 12/4/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This is a model class to hold the product information
public class Product:Decodable{
    
    public var id = -1;
    public var name:String?
    public var price = 0.0;
    public var isImported = false;
    public var category:String?
    public var imageSrc: String?
    
}
