//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/20/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
    // code
    
    override func viewDidLoad() {
        navigationItem.title = "Submit locaiton"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAddEnterLocation))
    }
    
    
    
}
