//
//  ResultSearchTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit


class ResultSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var resultPicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var preparationTimeLabel: UILabel!
    
    func configure(title: String, detail: String, preparationTime: String, imageUrl: String) {
        resultPicture.image = nil
        titleLabel.text = title
        detailLabel.text = detail
        preparationTimeLabel.text = preparationTime
        resultPicture.imageFromServerURL(urlString: imageUrl, PlaceHolderImage: UIImage.init() )
    }
}
