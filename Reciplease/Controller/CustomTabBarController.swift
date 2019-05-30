//
//  CustomTabBarController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 30/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    @IBOutlet var customTabBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBarView.frame.size.width = self.view.frame.width
        customTabBarView.frame.size.height = 70
        self.view.addSubview(customTabBarView)
        customTabBarView.frame.origin.y = self.view.frame.height - customTabBarView.frame.height
    }
    
    @IBAction func changeTab(_ sender: UIButton) {
        self.selectedIndex = sender.tag
    }

}
