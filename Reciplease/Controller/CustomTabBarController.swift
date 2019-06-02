//
//  CustomTabBarController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 30/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    // MARK: Outlets

    @IBOutlet var customTabBarView: UIView!

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: Private Properties

    var searchSelected: Int = 0 {
        didSet {
            if searchSelected == 0 {
                searchButton.isHighlighted = false
                favoriteButton.isHighlighted = true
            } else {
                searchButton.isHighlighted = true
                favoriteButton.isHighlighted = false
            }
        }
    }
    
    // MARK: View Methods
    
    // When the view is loaded, set:
    // Width same as the screen
    // Hight as 70
    // Add it to the main view
    // Put it at the bottom of the screen ( to replace the origin tab bar )
    override func viewDidLoad() {
        customTabBarView.frame.size.width = self.view.frame.width
        customTabBarView.frame.size.height = 70
        self.view.addSubview(customTabBarView)
        customTabBarView.frame.origin.y = self.view.frame.height - customTabBarView.frame.height
        super.viewDidLoad()
    }

    // If the user leave the app, save the current state
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(searchSelected, forKey: "SelectedState")
        super.encodeRestorableState(with: coder)
    }
    
    // If the user come back on the app, restore the current state
    override func decodeRestorableState(with coder: NSCoder) {
        searchSelected = Int(coder.decodeInt32(forKey: "SelectedState"))
        super.decodeRestorableState(with: coder)
    }

    // MARK: Actions

    // When the user press on one of the button, we change of tab
    @IBAction func changeTab(_ sender: UIButton) {
        searchSelected = sender.tag
        self.selectedIndex = sender.tag
    }
}
