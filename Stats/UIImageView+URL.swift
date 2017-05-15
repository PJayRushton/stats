//
//  UIImageView+URL.swift
//  Stats
//
//  Created by Parker Rushton on 5/15/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(from url: URL, withPlaceholder placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            }.resume()
    }
    
}
