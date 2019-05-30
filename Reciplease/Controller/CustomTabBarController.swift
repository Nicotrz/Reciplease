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
        let tabBarHeight = self.tabBar.frame.size.height
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        customTabBarView.frame.size.width = self.view.frame.width
        customTabBarView.frame.size.height = tabBarHeight
        self.view.addSubview(customTabBarView)
        customTabBarView.frame.origin.y = self.view.frame.height - bottomSafeAreaHeight - customTabBarView.frame.height
    }
    
    @IBAction func changeTab(_ sender: UIButton) {
        self.selectedIndex = sender.tag
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
