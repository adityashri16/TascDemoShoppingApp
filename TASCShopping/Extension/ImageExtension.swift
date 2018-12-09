//
//  ImageExtension.swift
//  TASCShopping
//  Created by impadmin on 12/6/18.
//  Copyright © 2018 impadmin. All rights reserved.
//

import Foundation
import UIKit

/*  This extension is created to add a feature to the UIImageview so that it can download the image from provided url and display.
 Reference taken from stack overflow from Leo Dabus's post: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift */

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
