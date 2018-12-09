//
//  GetProductListService.swift
//  TASCShopping
//
//  Created by impadmin on 12/5/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
//This service class is to fetch the product list.
//For now we are giving a hard-coded list here which can be later replaced with an actual server call in real app.
//This class should be used to interact with product list
public class ProductListService {
    
    let jsonData =
        "[{\"id\": 1,\"category\": \"Candy\",\"name\": \"16lb bag of Skittles\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/71-FuIRa7fL._SY355_.jpg\",\"price\": 16.00,\"isImported\" : false},{\"id\": 2,\"category\": \"Audio Player\",\"name\": \"Walkman\",\"imageSrc\": \"https://brain-images-ssl.cdn.dixons.com/8/0/10143508/l_10143508_003.jpg\",\"price\": 99.99,\"isImported\" : false},{\"id\": 3,\"category\": \"Popcorn\",\"name\": \"Bag of Microwave Popcorn\",\"imageSrc\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSITr_T-lVoh70y32v9urDr14wBZ_uzxW72Y3A0Gd1gnoMD8hyEzA\",\"price\": 0.99,\"isImported\" : false},{\"id\": 4,\"category\": \"Coffee\",\"name\": \"Bag of Vanilla-Hazelnut Coffee\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/71O03W%2BGgcL._SY355_.jpg\",\"price\": 11.00,\"isImported\" : true},{\"id\": 5,\"category\": \"Scooter\",\"name\": \"Vespa\",\"imageSrc\": \"https://imgd.aeplcdn.com/310x174/bw/models/vespa-sxl-125-standard-839.jpg?20180813151835\",\"price\": 15001.25,\"isImported\" : true},{\"id\": 6,\"category\": \"Candy\",\"name\": \"Crate of Almond Snickers\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/714UEVY2qwL._SL1500_.jpg\",\"price\": 75.99,\"isImported\" : true},{\"id\": 7,\"category\": \"Audio Player\",\"name\": \"Discman\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/41V11X92B4L.jpg\",\"price\": 55.00,\"isImported\" : false},{\"id\": 8,\"category\": \"Alcohol\",\"name\": \"Bottle of Wine\",\"imageSrc\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQh43h6O5FhzgHkAaeaaH1Z9GzKJOBxq8RpfhBZlvU-Fun4TQgYJA\",\"price\": 10.00,\"isImported\" : true},{\"id\": 9,\"category\": \"Coffee\",\"name\": \"300# bag of Fair-Trade Coffee\",\"imageSrc\": \"https://i5.walmartimages.com/asr/442c8a05-b017-4b94-81e0-c14e15632309_1.617d164f24f7b0066e4da23065cf64a9.jpeg?odnHeight=450&odnWidth=450&odnBg=FFFFFF\",\"price\": 997.99,\"isImported\" : false}]"
    
    /*This is to simulate the data call from server.
     In reality the product list should come from some other source like server or cloud etc.*/
    public func getProductList( productsfetched:@escaping ([Product]?, Error?)-> Void){
        
        DispatchQueue(label: "products_list").asyncAfter(deadline: .now() + 1.0, execute: {
            //just parsing the json string
            do {
                let products = try JSONDecoder().decode([Product].self, from: self.jsonData.data(using: .utf8)!)
                productsfetched(products, nil)
                
            } catch {
                let errorFetchingProducts = TASCError.invalidProductJSON
                productsfetched(nil, errorFetchingProducts)
            }
            
        })
        
    }
    
    //just a simulation of getting more details of product
    public func getProductDetail(product:Product)->(ProductDetail?){
        let productDetail = ProductDetail()
        productDetail.product = product
        let taxes = TaxService.init().getTaxesForProduct(product: product)
        productDetail.taxes = taxes
        return productDetail
    }
    
}
