//
//  CartNavigationButton.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import UIKit
//This class is a helper class to create and handle the navigation button for cart.
class CartNavigationButton: NSObject {
    
    var countView:UILabel? = nil
    
    public func getCartNavigationIcon(withTarget target: NSObject,
                                      andAction action: Selector) -> UIButton
    {
        //create a custom button with cart image
        let cartButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        cartButton.setImage(UIImage(named: "cart"), for: .normal)
        cartButton.addTarget(target, action: action, for: .touchUpInside)
        
        //create a view to show count on the cart icon
        let countView = UILabel(frame: CGRect.init(x: 30, y: 5, width: 18, height: 18))
        countView.backgroundColor = UIColor.red
        countView.layer.cornerRadius = countView.frame.size.width/2
        countView.clipsToBounds = true
        countView.text = String(CartService.shared.getCart().count)
        countView.textColor = UIColor.white
        countView.textAlignment = .center
        
        self.countView = countView
        
        cartButton.addSubview(countView)
        
        return cartButton
    }
}
