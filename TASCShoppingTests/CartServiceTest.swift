//
//  CartServiceTest.swift
//  TASCShoppingTests
//
//  Created by impadmin on 12/8/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import XCTest
@testable import TASCShopping

//this test class tests the main functionalities of CartService
class CartServiceTest: XCTestCase {
    
    let cartService =  CartService.shared
    
    private let productMockJson =
    "[{\"id\": 1,\"category\": \"Candy\",\"name\": \"16lb bag of Skittles\",\"imageSrc\": \"https://images-na.ssl-images-amazon.com/images/I/71-FuIRa7fL._SY355_.jpg\",\"price\": 16.00,\"isImported\" : false},{\"id\": 2,\"category\": \"Audio Player\",\"name\": \"Walkman\",\"imageSrc\": \"https://brain-images-ssl.cdn.dixons.com/8/0/10143508/l_10143508_003.jpg\",\"price\": 99.99,\"isImported\" : false},{\"id\": 3,\"category\": \"Popcorn\",\"name\": \"Bag of Microwave Popcorn\",\"imageSrc\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSITr_T-lVoh70y32v9urDr14wBZ_uzxW72Y3A0Gd1gnoMD8hyEzA\",\"price\": 0.99,\"isImported\" : false}]"
    
    override func setUp() {
        //no setup required
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.cartService.clearCart()
    }
    
    //this test checks the logic of adding and removing items on the same instance of cart
    func testAddRemoveCartItem() {
       
        do {
            //get mock products list
            let products = try JSONDecoder().decode([Product].self,
                                            from:self.productMockJson.data(using: .utf8)!)
            
            //create cart items and add to cart
            for product:Product in products {
                
                let cartItem = CartItem()
                cartItem.product = product
                cartItem.quantity = 1
                if (product.id == 2) {
                    //For walkman sales tax is applied, for other two products there is no tax
                    
                    let tax = getTax(taxType: .basicSalesTax)
                    cartItem.taxes = [tax]
                }
                
                //add items to cart
                self.cartService.addUpdateItemToCart(cartItem: cartItem)
            }
            
            //check the cart status after adding
            XCTAssertTrue(cartService.getCart().count == 3, "Cart Item count should be 3")
            XCTAssertTrue(cartService.getCart().first?.product?.name == "16lb bag of Skittles", "First product name should be '16lb bag of Skittles'")
            
            //Now remove an item from the same cart and test
            self.cartService.removeItemAtIndex(index: 1)
            
             //check the cart status after removing
            XCTAssertTrue(cartService.getCart().count == 2, "Cart Item count should be 2 now")
            XCTAssertTrue(cartService.getCart().first?.product?.name == "16lb bag of Skittles")
            XCTAssertTrue(cartService.getCart()[1].product?.name == "Bag of Microwave Popcorn")
            
            //Now remove all
            self.cartService.clearCart()
            
            //check the cart status after removing
            XCTAssertTrue(cartService.getCart().count == 0, "Cart Item count should be 0 now")
        }
        catch {
            XCTAssertTrue(false, "Exception occured")
        }
    }
    
    
    //this test checks the logic of finding index of a cart item in the cart
    func testItemIndexInCart() {
        
        do {
            //get mock products list
            let products = try JSONDecoder().decode([Product].self,
                                            from:self.productMockJson.data(using: .utf8)!)
            
            //create cart items and add to cart
            for product:Product in products {
                
                let cartItem = CartItem()
                cartItem.product = product
                cartItem.quantity = 1
                if (product.id == 2) {
                    //For walkman sales tax is applied, for other two products there is no tax
                    
                    let tax = getTax(taxType: .basicSalesTax)
                    cartItem.taxes = [tax]
                }
                //add items to cart
                self.cartService.addUpdateItemToCart(cartItem: cartItem)
            }
            
            
            var index = self.cartService.itemIndexInCart(cartItem: self.cartService.getCart()[1])
            XCTAssertTrue(index == 1, "Index should be 1")
            
            //create a random cart item
            let nonExistingItem = CartItem()
            //create dummy product
            let product = Product()
            product.id = 999
            product.name = "Acme"
            product.category = "None"
            product.imageSrc = ""
            product.isImported = false
            product.price = 0.0
            nonExistingItem.product = product
            //create dummy taxes
            nonExistingItem.taxes = []
            
            //find this item in cart
            index = self.cartService.itemIndexInCart(cartItem: nonExistingItem)
            //should not be found
            XCTAssertNil(index, "Index should be nil")
            
            
        }catch{
             XCTAssertTrue(false, "Exception occured")
        }
    }
    
    //helper method for mocking taxes
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
