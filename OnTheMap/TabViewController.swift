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
    
    // Acitivity indicator
    var activityIndicator = UIActivityIndicatorView()
    
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
    
    @IBAction func reloadData(_ sender: Any) {
        view.alpha = CGFloat(0.75)
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NotificationCenter.default.post(name: Notification.Name(rawValue:  "SuccessNotification"), object: self)
        
        // Get the updated data
        OTMClient.sharedInstance().getStudentLocations { (students, error) in
            if error == nil {
                OTMClient.Students.OTMStudentsArray = students!
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.view.alpha = CGFloat(1.00)
                    self.view.reloadInputViews()
                    print("Reload worked")
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.view.alpha = CGFloat(1.00)
                self.view.reloadInputViews()
            }
        }
    }

    
}
