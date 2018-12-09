//
//  TaxServiceTest.swift
//  TASCShoppingTests
//
//  Created by impadmin on 12/8/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import XCTest
@testable import TASCShopping

//this test class tests the main functionalities of TaxService
class TaxServiceTest: XCTestCase {

    override func setUp() {
        //not required
    }

    override func tearDown() {
      //not required
    }

    //test the taxes returned for a product
    func testGetTaxesForProduct() {
        
        let productMockJson =
        "[{\"id\": 1,\"category\": \"Candy\",\"name\": \"16lb bag of Skittles\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/71-FuIRa7fL._SY355_.jpg\",\"price\": 16.00,\"isImported\" : false},{\"id\": 5,\"category\": \"Scooter\",\"name\": \"Vespa\",\"imageSrc\": \"https://imgd.aeplcdn.com/310x174/bw/models/vespa-sxl-125-standard-839.jpg?20180813151835\",\"price\": 15001.25,\"isImported\" : true},{\"id\": 6,\"category\": \"Candy\",\"name\": \"Crate of Almond Snickers\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/714UEVY2qwL._SL1500_.jpg\",\"price\": 75.99,\"isImported\" : true}]"
        
        do {
            //get mock products list
            let products = try JSONDecoder().decode([Product].self,
                                                    from:productMockJson.data(using: .utf8)!)
            
            
            //verify taxes on item with no applicable tax
            let productWithNoTax = products[0];//candy item
            var taxes = TaxService.init().getTaxesForProduct(product: productWithNoTax)
            XCTAssertEqual(taxes?.count, 0, "No taxes should be present for this item")
            
            //verify taxes on item with basic sales tax and import duty
            let productWithAllTax = products[1];//scooter item
            taxes = TaxService.init().getTaxesForProduct(product: productWithAllTax)
            XCTAssertEqual(taxes?.count, 2, "2 taxes should be present for this item")
            
            //first tax will be sales tax
            //percentage of basic tax should be 10.0
            let taxBasic = taxes?[0]
            XCTAssertEqual(taxBasic?.taxPercentage, 10.0)
            
            //verify taxes on item with only import duty
            let productWithImportTax = products[2];//imported candy item
            taxes = TaxService.init().getTaxesForProduct(product: productWithImportTax)
            XCTAssertEqual(taxes?.count, 1, "2 taxes should be present for this item")
            
            //percentage of import tax should be 5.0
            let taxImport = taxes?[0]
            XCTAssertEqual(taxImport?.taxPercentage, 5.0)
            
            
        }catch{
            XCTAssertTrue(false, "Exception occured")
        }
        
    }

   
}
