//
//  LoadingCellTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 28/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class LoadingCellTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    // Method to (des)activate the animation of the Activity indicator
    func changeStatusLoadingInterface(activate: Bool) {
        if activate {
        loadingActivityIndicator.startAnimating()
        } else {
            loadingActivityIndicator.stopAnimating()
        }
    }
}
