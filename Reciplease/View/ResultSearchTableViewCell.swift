//
//  ResultSearchTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

class ResultSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var resultPicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var preparationTimeLabel: UILabel!
    
    func configure(title: String, detail: String, preparationTime: String, imageUrl: String) {
        titleLabel.text = title
        detailLabel.text = detail
        preparationTimeLabel.text = "\(preparationTime)'"
        resultPicture.imageFromServerURL(urlString: imageUrl, PlaceHolderImage: UIImage.init() )
    }
}
