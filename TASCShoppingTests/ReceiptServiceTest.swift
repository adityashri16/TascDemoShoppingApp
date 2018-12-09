//
//  ReceiptServiceTest.swift
//  TASCShoppingTests
//
//  Created by impadmin on 12/8/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import XCTest
@testable import TASCShopping

//This class tests the generation of receipts from cart items.
//The test cases replicate the inputs and expected outputs given in the excercie
class ReceiptServiceTest: XCTestCase {
    let cartService =  CartService.shared
    
    override func setUp() {
        //not required
    }

    override func tearDown() {
        self.cartService.clearCart()
    }

    /**
     Input:
    1 16lb bag of Skittles at 16.00
    1 Walkman at 99.99
    1 bag of microwave Popcorn at 0.99

     Output:
     1 16lb bag of Skittles: 16.00
     1 Walkman: 109.99
     1 bag of microwave Popcorn: 0.99
     Sales Taxes: 10.00
     Total: 126.98
     
    */
    func testGetReceipt1() {
        
        let productMockJson = "[{\"id\": 1,\"category\": \"Candy\",\"name\": \"16lb bag of Skittles\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/71-FuIRa7fL._SY355_.jpg\",\"price\": 16.00,\"isImported\" : false},{\"id\": 2,\"category\": \"Audio Player\",\"name\": \"Walkman\",\"imageSrc\": \"https://brain-images-ssl.cdn.dixons.com/8/0/10143508/l_10143508_003.jpg\",\"price\": 99.99,\"isImported\" : false},{\"id\": 3,\"category\": \"Popcorn\",\"name\": \"Bag of Microwave Popcorn\",\"imageSrc\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSITr_T-lVoh70y32v9urDr14wBZ_uzxW72Y3A0Gd1gnoMD8hyEzA\",\"price\": 0.99,\"isImported\" : false}]"
        
        do {
            //get mock products list
            let products = try JSONDecoder().decode([Product].self,
                                                    from:productMockJson.data(using: .utf8)!)
            
            //create cart items and add to cart
            for product:Product in products {
                
                let cartItem = CartItem()
                cartItem.product = product
                cartItem.quantity = 1
                
                if(product.id == 2){ //add basic tax for walkman
                    cartItem.taxes = []
                    let tax = getTax(taxType: .basicSalesTax)
                    cartItem.taxes?.append(tax)
                }
                
                //add items to cart
                self.cartService.addUpdateItemToCart(cartItem: cartItem)
            }
            
            XCTAssertEqual(self.cartService.getCart().count, 3, "There should be 3 items in the cart")
            
            let receipt = ReceiptService.init().calculateReceipt()
            
            XCTAssertEqual(receipt.items?.count, 3, "There should be 3 receipts items")
            
            /*
             1 16lb bag of Skittles: 16.00
             1 Walkman: 109.99
             1 bag of microwave Popcorn: 0.99
             */
            
            var item = receipt.items?[0]
            XCTAssertEqual(item?.totalPrice, 16.00, "1 16lb bag of Skittles price should be 16.00")
            
            item = receipt.items?[1]
            XCTAssertEqual(item?.totalPrice, 109.99, "1 Walkman price should be 109.99")
            
            item = receipt.items?[2]
            XCTAssertEqual(item?.totalPrice, 0.99, "1 bag of microwave Popcorn should be 0.99")
            
            //rounding the expected outcome as we are comparing with the output that is displayed.
            XCTAssertEqual(receipt.grandTotal, 126.98, "Total amount should be 126.98")
            
            XCTAssertEqual(receipt.totalTaxes, 10.00, "Total tax amount should be 10.00")
            
            
        }
        catch {
            XCTAssertTrue(false, "Exception occured")
        }
    }
    
    /**
     Input:
     1 imported bag of Vanilla-Hazelnut Coffee at 11.00
     1 Imported Vespa at 15,001.25
     
     Output:
     1 imported bag of Vanilla-Hazelnut Coffee: 11.55
     1 Imported Vespa: 17,251.5
     Sales Taxes: 2,250.8
     Total: 17,263.05
     */
    
    func testGetReceipt2() {
        
        let productMockJson = "[{\"id\": 4,\"category\": \"Coffee\",\"name\": \"Bag of Vanilla-Hazelnut Coffee\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/71O03W%2BGgcL._SY355_.jpg\",\"price\": 11.00,\"isImported\" : true},{\"id\": 5,\"category\": \"Scooter\",\"name\": \"Vespa\",\"imageSrc\": \"https://imgd.aeplcdn.com/310x174/bw/models/vespa-sxl-125-standard-839.jpg?20180813151835\",\"price\": 15001.25,\"isImported\" : true}]"
        
        do {
            //get mock products list
            let products = try JSONDecoder().decode([Product].self,
                                                    from:productMockJson.data(using: .utf8)!)
            
            //create cart items and add to cart
            for product:Product in products {
                
                let cartItem = CartItem()
                cartItem.product = product
                cartItem.quantity = 1
                cartItem.taxes = []
                
                if(product.id == 4){ //add only import tax for imported Coffee
                    let tax = getTax(taxType: .importDuty)
                    cartItem.taxes?.append(tax)
                }
                else if(product.id == 5){ //add both taxes for scooter
                    let tax = getTax(taxType: .basicSalesTax)
                    cartItem.taxes?.append(tax)
                    let importTax = getTax(taxType: .importDuty)
                    cartItem.taxes?.append(importTax)
                }
                
                //add items to cart
                self.cartService.addUpdateItemToCart(cartItem: cartItem)
            }
            
            XCTAssertEqual(self.cartService.getCart().count, 2, "There should be 2 items in the cart")
            
            let receipt = ReceiptService.init().calculateReceipt()
            
            XCTAssertEqual(receipt.items?.count, 2, "There should be 2 receipts items")
            
            var item = receipt.items?[0]
            XCTAssertEqual(item?.totalPrice, 11.55, "1 imported bag of Vanilla-Hazelnut Coffee price should be 11.55")
            
            item = receipt.items?[1]
            XCTAssertEqual(item?.totalPrice, 17251.5, "1 Imported Vespa price should be 17,251.5")
            
            XCTAssertEqual(receipt.grandTotal, 17263.05, "Total amount should be 17263.05")
            
            XCTAssertEqual(receipt.totalTaxes, 2250.8, "Total tax amount should be 2250.8")
            
        }
        catch {
            XCTAssertTrue(false, "Exception occured")
        }
        
    }
    /*
     Input:
     1 imported crate of Almond Snickers at 75.99
     1 Discman at 55.00
     1 Imported Bottle of Wine at 10.00
     1 300# bag of Fair-Trade Coffee at 997.99
     
     1 imported crate of Almond Snickers: 79.79
     1 Discman: 60.5
     1 imported bottle of Wine: 11.5
     1 300# Bag of Fair-Trade Coffee: 997.99
     Sales Taxes: 10.8
     Total: 1,149.78
     
     */
    func testGetReceipt3() {
        
        let productMockJson = "[{\"id\": 6,\"category\": \"Candy\",\"name\": \"Crate of Almond Snickers\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/714UEVY2qwL._SL1500_.jpg\",\"price\": 75.99,\"isImported\" : true},{\"id\": 7,\"category\": \"Audio Player\",\"name\": \"Discman\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/41V11X92B4L.jpg\",\"price\": 55.00,\"isImported\" : false},{\"id\": 8,\"category\": \"Alcohol\",\"name\": \"Bottle of Wine\",\"imageSrc\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQh43h6O5FhzgHkAaeaaH1Z9GzKJOBxq8RpfhBZlvU-Fun4TQgYJA\",\"price\": 10.00,\"isImported\" : true},{\"id\": 9,\"category\": \"Coffee\",\"name\": \"300# bag of Fair-Trade Coffee\",\"imageSrc\": \"https://i5.walmartimages.com/asr/442c8a05-b017-4b94-81e0-c14e15632309_1.617d164f24f7b0066e4da23065cf64a9.jpeg?odnHeight=450&odnWidth=450&odnBg=FFFFFF\",\"price\": 997.99,\"isImported\" : false}]"
        
        do {
            //get mock products list
            let products = try JSONDecoder().decode([Product].self,
                                                    from:productMockJson.data(using: .utf8)!)
            
            //create cart items and add to cart
            for product:Product in products {
                
                let cartItem = CartItem()
                cartItem.product = product
                cartItem.quantity = 1
                cartItem.taxes = []
                
                switch(product.id){
                case 6:
                    //add only import tax for imported Candy
                    let tax = getTax(taxType: .importDuty)
                    cartItem.taxes?.append(tax)
                    break
                case 7:
                    //add only basic tax for Audio player
                    let tax = getTax(taxType: .basicSalesTax)
                    cartItem.taxes?.append(tax)
                    break
                case 8:
                    //add both tax for Alchohol
                    let impTax = getTax(taxType: .importDuty)
                    cartItem.taxes?.append(impTax)
                    let tax = getTax(taxType: .basicSalesTax)
                    cartItem.taxes?.append(tax)
                    break
                default: //no tax for coffee
                    break
                }
                
                //add items to cart
                self.cartService.addUpdateItemToCart(cartItem: cartItem)
            }
            
            XCTAssertEqual(self.cartService.getCart().count, 4, "There should be 4 items in the cart")
            
            let receipt = ReceiptService.init().calculateReceipt()
            
            XCTAssertEqual(receipt.items?.count, 4, "There should be 4 receipts items")
            
            var item = receipt.items?[0]
            XCTAssertEqual(item?.totalPrice, 79.79, "1 imported crate of Almond Snickers price should be 79.79")
            
            item = receipt.items?[1]
            XCTAssertEqual(item?.totalPrice, 60.5, "1 Discman price should be 60.5")
            
            item = receipt.items?[2]
            XCTAssertEqual(item?.totalPrice, 11.5, "1 imported bottle of Wine price should be 11.5")
            
            item = receipt.items?[3]
            XCTAssertEqual(item?.totalPrice, 997.99, "1 300# Bag of Fair-Trade Coffee price should be 997.99")
            
            
            XCTAssertEqual(receipt.grandTotal, 1149.78, "Total amount should be 1,149.78")
            
            XCTAssertEqual(receipt.totalTaxes, 10.8, "Total tax amount should be 10.8")
            
        }
        catch {
            XCTAssertTrue(false, "Exception occured")
        }
    }
    
    
    enum Taxes {
        case basicSalesTax
        case importDuty
    }
    private func getTax(taxType:Taxes)->Tax {
        
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
