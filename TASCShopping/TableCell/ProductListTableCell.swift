//
//  ProductListTableCell.swift
//  TASCShopping
//
//  Created by impadmin on 12/4/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
import UIKit

public class ProductListTableCell: UITableViewCell{
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    
    public override func prepareForReuse() {
        self.productImageView.image = nil
    }
    
}
