//
//  ProductDetailViewController.swift
//  TASCShopping
//
//  Created by impadmin on 12/4/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var quatityInputTextBox: UITextField!
    
    @IBOutlet weak var taxesTitle: UILabel!
    var detailItem: Product?
    private var productDetail:ProductDetail?
    private var quantity = 1
    let cartButton = CartNavigationButton.init()
    
    // MARK: - view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setCartButton()
        
        //Ideally, here we should get only the product Id and then make a server call to fetch more details for the product.
        //We are using the same product object as for list here for excercise purpose.
        if let product = self.detailItem{
            self.productDetail = ProductListService.init().getProductDetail(product: product)
            configureView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartStatus), name: .didUpdateCart, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartStatus()
    }
    
    // MARK: - business logic methods
    func processsAndAddToCart(){
        
        if let detail = self.productDetail{
            let cartItem = CartItem()
            cartItem.product = detail.product
            cartItem.taxes = detail.taxes
            cartItem.quantity = Int(self.quatityInputTextBox.text!) ?? self.quantity
            
            //check if product is already in cart
            showAlert(title:"Added", message: "Item successfully added to your cart!")
            CartService.shared.addUpdateItemToCart(cartItem: cartItem)
            
        }
        
    }
    
    // MARK: - UI helper methods
    func configureView() {
        
        //Adding tap gesture recognizer to dismiss keyboard when user taps outside of keyboard
        self.addTapGestureRecognizer()
        
        // Update the user interface for the detail item.
        if let item = self.productDetail{
            
            if let product = item.product{
                if let productImgSrc = product.imageSrc{
                    self.productImageView.downloaded(from: productImgSrc)
                }
                else{
                    //some default picture
                    self.productImageView.image = UIImage.init()
                }
                productTitle.text = product.name
                
                price.text = product.price.toPriceDisplayString()
                
                categoryTitle.text = product.category
                
                quatityInputTextBox.text = String(self.quantity)
                
                let appliedTax =  item.taxesString.isEmpty ? "None" : item.taxesString
                taxesTitle.text = "Taxes: " + appliedTax
                
            }
            
        }
        
    }
    
    private func addTapGestureRecognizer()
    {
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self,
                                                               action: #selector(onTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setCartButton(){
        
        let button = self.cartButton.getCartNavigationIcon(withTarget: self, andAction: #selector(self.showCartView))
        
        let rightBarButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    //MARK - actions
    @objc private func onTap(_ sender:Any?)
    {
        self.quatityInputTextBox.resignFirstResponder()
    }
    
    @objc func showCartView(){
        
        let vc = CartViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func updateCartStatus(){
        let count = CartService.shared.getCart().count
        if(count > 0){
            self.cartButton.countView?.isHidden = false
            self.cartButton.countView?.text = String(CartService.shared.getCart().count)
        }else{
            self.cartButton.countView?.isHidden = true
        }
        
    }
    
    @IBAction func addToCart(_ sender: Any) {
        self.processsAndAddToCart()
    }
    
    
}
