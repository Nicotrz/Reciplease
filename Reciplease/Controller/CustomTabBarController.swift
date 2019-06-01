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

    // MARK: Actions

    // When the user press on one of the button, we change of tab
    @IBAction func changeTab(_ sender: UIButton) {
        self.selectedIndex = sender.tag
    }

}
