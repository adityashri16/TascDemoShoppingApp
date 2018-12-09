//
//  CartService.swift
//  TASCShopping
//
//  Created by impadmin on 12/6/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
/*This service class should be used to interact with the cart. This is a singleton class to keep the uniform cart status for a user session.
The operations performed can be done on server in the real app.*/
class CartService{
    
    static let shared = CartService()
    
    private var cartItems:[CartItem] = []
    
    private init(){}
    
    /*This method adds the new cart item to cart of not present. If the cart item is already present in the cart,
    then it just increases the quantity if existing item by the quantity set while adding the item.*/
    func addUpdateItemToCart(cartItem:CartItem){
        
        //update if item is present
        if let itemIndex = itemIndexInCart(cartItem: cartItem){
            
            self.cartItems[itemIndex].quantity += cartItem.quantity
            
        }
        else{
            self.cartItems.append(cartItem)
        }
        //post notification so that UI can be updated
        NotificationCenter.default.post(name: .didUpdateCart, object: nil)
        
    }
    
    //Removes the item at given index from the cart.
    func removeItemAtIndex(index:Int){
        if(!self.cartItems.isEmpty && index < self.cartItems.count){
            self.cartItems.remove(at: index)
            //post notification so that UI can be updated
            NotificationCenter.default.post(name: .didUpdateCart, object: nil)
        }
    }
    
    //Returns the current cart
    func getCart()->[CartItem]{
                return self.cartItems
    }
    
    //Removes all the items from the cart
    func clearCart(){
        self.cartItems.removeAll()
        NotificationCenter.default.post(name: .didUpdateCart, object: nil)
    }
    
    //Returns the index of the cart item provided in the cart
    func itemIndexInCart(cartItem:CartItem)->Int?{
        
        return self.cartItems.firstIndex(where: { (existingItem:CartItem) -> Bool in
            
            return (existingItem.product?.id == cartItem.product?.id)
            
        })
    }
    
    
}
