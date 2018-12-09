//
//  ProductListViewController.swift
//  TASCShopping
//
//  Created by impadmin on 12/4/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import UIKit

class ProductListViewController: UITableViewController {
    
    var detailViewController: ProductDetailViewController? = nil
    
    var progressIndicator = UIActivityIndicatorView()
    let cartButton = CartNavigationButton.init()
    
    var productList:Array<Product>? {
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        ProductListService.init().getProductList(productsfetched: { (products, error) -> Void in
            
            DispatchQueue.main.sync {
                
                self.stopActivity()
                
                if let productsFound = products {
                    self.productList = productsFound
                    
                } else {
                    //No products found
                    //Here conditonal error handling can be done based on the error code returned from the service
                    self.showAlert(title: "No products!", message: "No products could be found at the moment! Please try later.")
                    
                }
            }
            
        })
        startActivity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartStatus), name: .didUpdateCart, object: nil)
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        updateCartStatus()
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let products = self.productList{
                    let object = products[indexPath.row]
                    let controller = (segue.destination as! UINavigationController).topViewController as! ProductDetailViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    
                }
            }
        }
    }
    
    
     // MARK: - Table View
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.productList?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductListTableCell else {
            return UITableViewCell.init()
        }
        if let products = self.productList{
            let product = products[indexPath.row]
            cell.productName.text = product.name
            cell.price.text = product.price.toPriceDisplayString()
            cell.category.text = product.category
            
            if let productImgSrc = product.imageSrc{
                cell.productImageView.downloaded(from: productImgSrc)
            }
            else{
                cell.productImageView.image = UIImage.init()
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     // MARK: - UI Helper methods
    
    func setCartButton(){
        //do not show cart button on ipad on this controller, the detail view will have it.
        if(UIDevice.current.userInterfaceIdiom != .pad){
            let button = self.cartButton.getCartNavigationIcon(withTarget: self, andAction: #selector(self.showCart))
            
            let rightBarButton = UIBarButtonItem(customView: button)
            
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    func setupUI(){
        
        setCartButton()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ProductDetailViewController
        }
        
        let tableCellNib = UINib.init(nibName: "ProductListTableCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "ProductCell")
        
        setUpProgressIndicator()
    }
    
    func setUpProgressIndicator() {
        progressIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        progressIndicator.style = UIActivityIndicatorView.Style.gray
        progressIndicator.center = self.view.center
        self.view.addSubview(progressIndicator)
    }
    
    func startActivity(){
        progressIndicator.startAnimating()
        progressIndicator.backgroundColor = UIColor.white
    }
    
    func stopActivity(){
        progressIndicator.stopAnimating()
        progressIndicator.hidesWhenStopped = true
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
     // MARK: - actions
    @objc func updateCartStatus(){
        
        let count = CartService.shared.getCart().count
        if(count > 0){
            self.cartButton.countView?.isHidden = false
            self.cartButton.countView?.text = String(CartService.shared.getCart().count)
        }else{
            self.cartButton.countView?.isHidden = true
        }
        
    }
    
    @objc func showCart() {
        let vc = CartViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}

