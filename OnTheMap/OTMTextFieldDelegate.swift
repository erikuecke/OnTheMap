//
//  OTMTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/19/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class OTMTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Dismiss keyboard on hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
