//
//  CartTableViewCellDelegate.swift
//  TASCShopping
//
//  Created by impadmin on 12/8/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import UIKit

protocol CartTableViewCellDelegate {
    func didSelectToRemoveItemAtIndex(index:Int)
}
