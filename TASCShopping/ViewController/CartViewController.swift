//
//  CartViewController.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import UIKit

//This class is a controller to handle the cart. It shows the cart items and allows user to update the cart.
class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    @IBOutlet weak var emptyCartButton: UIButton!
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var noItemsMessageView: UILabel!
    
    // MARK: - View methods
    override func viewDidLoad() {
        
        self.title = "Your cart"
        
        //initialize table
        let tableCellNib = UINib.init(nibName: "CartListTableViewCell", bundle: nil)
        self.cartTable.register(tableCellNib, forCellReuseIdentifier: "CartCell")
        
        self.cartTable.reloadData()
        updateCartStatus()
        
         NotificationCenter.default.addObserver(self, selector: #selector(updateCartStatus), name: .didUpdateCart, object: nil)
    }
    
    
    // MARK: - Tabel view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartService.shared.getCart().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.cartTable.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartListTableViewCell else {
            return UITableViewCell.init()
        }
        return configureCell(cell: cell, indexPath: indexPath)
        
    }
    
    
    // MARK: - UI helper methods
    //populates the cart cell item with the values
    func configureCell(cell:CartListTableViewCell, indexPath:IndexPath)->(CartListTableViewCell){
        
        let cartItem = CartService.shared.getCart()[indexPath.row]
        
        if let product = cartItem.product{
            cell.productName.text = product.name
            if let productImgSrc = product.imageSrc{
                cell.productImageView.downloaded(from: productImgSrc)
            }
            else{
                cell.productImageView.image = UIImage.init()
            }
            
        }
        cell.quantityView.text = "Qty:" + String(cartItem.quantity)
        cell.totalPriceView.text = "Total Price:" + cartItem.totalAmount.toPriceDisplayString()
        cell.totalTaxesView.text = "Taxes(Included):" + cartItem.totalTaxAmount.toPriceDisplayString()
        
        cell.delegate = self;
        cell.index = indexPath.row
        
        return cell
    }
    
    
    // MARK: - Actions
    
    //clear the cart
    @IBAction func emptyCartAction(_ sender: Any) {
        CartService.shared.clearCart()
        self.cartTable.reloadData()
    }
    
    //check out the cart
    @IBAction func checkOutAction(_ sender: Any) {
        
        let vc = ReceiptViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //This function updates the views when cart is updated.
    @objc func updateCartStatus(){
        
        if(CartService.shared.getCart().count > 0){
            self.noItemsMessageView.isHidden = true
            self.cartTable.isHidden = false
        }
        else{
            self.noItemsMessageView.isHidden = false
            self.cartTable.isHidden = true
        }
        
    }
    
    //This function removes the selected item from cart
    func didSelectToRemoveItemAtIndex(index: Int) {
         CartService.shared.removeItemAtIndex(index: index)
          self.cartTable.reloadData()
    }
    
   
 
}
