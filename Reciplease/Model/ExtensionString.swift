//
//  ExtensionString.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

extension String {

    // Calculated property to know if there is any special character in the string
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z ].*"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
}
