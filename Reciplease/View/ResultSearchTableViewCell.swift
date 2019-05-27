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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String, detail: String, like: String, preparationTime: String) {
        titleLabel.text = title
        detailLabel.text = detail
        likeLabel.text = like
        preparationTimeLabel.text = preparationTime
    }
}
