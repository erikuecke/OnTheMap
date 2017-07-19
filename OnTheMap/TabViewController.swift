//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/19/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController, UINavigationControllerDelegate {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        OTMClient.sharedInstance().deleteUdacitySession { (success, errorSTring) in
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
       
}
