//
//  ResultSearchTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class ResultSearchTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var resultPicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var preparationTimeLabel: UILabel!

    // MARK: View Methods

    // When the image is going to be reuse, we set it at nil to avoid
    // an old image on a new cell
    override func prepareForReuse() {
        resultPicture.image = nil
        super.prepareForReuse()
    }

    // Configure the outlets with information sended
    func configure(title: String, detail: String, preparationTime: String, imageUrl: String) {
        titleLabel.text = title
        detailLabel.text = detail
        preparationTimeLabel.text = preparationTime
        resultPicture.imageFromServerURL(urlString: imageUrl, placeHolderImage: UIImage.init() )
    }
}
