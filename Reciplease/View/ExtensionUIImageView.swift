//
//  ExtensionUIImageView.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

extension UIImageView {

    // This function take the url from an image to show it on a UIImage Object
    public func imageFromServerURL(urlString: String, placeHolderImage: UIImage) {
        if self.image == nil {
            self.image = placeHolderImage
        }

        URLSession.shared.dataTask(
            with: NSURL(string: urlString)! as URL, completionHandler: { (data, _, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }

}
