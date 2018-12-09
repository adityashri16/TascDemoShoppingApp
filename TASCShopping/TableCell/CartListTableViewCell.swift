//
//  CartListTableViewCell.swift
//  TASCShopping
//
//  Created by impadmin on 12/7/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
import UIKit

public class CartListTableViewCell: UITableViewCell{

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var totalPriceView: UILabel!
    @IBOutlet var totalTaxesView: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var quantityView: UILabel!
    
    var index:Int?
    var delegate:CartTableViewCellDelegate?
    
    @IBAction func removeItemFromCart(_ sender: Any) {
        if let cartCellDelegate = self.delegate{
            cartCellDelegate.didSelectToRemoveItemAtIndex(index: self.index ?? -1)
        }
    }
    
    public override func prepareForReuse() {
        self.productImageView.image = nil
    }
}

