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
      //  NotificationCenter.default.post(name: Notification.Name(rawValue:  "SuccessNotification"), object: self)
        
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

    @IBAction func addStudentLocation(_ sender: Any) {
        

        // Get single student locatino if available.
        OTMClient.sharedInstance().getOneStudentLocation { (success, student, errorString) in
            if success {
                if student != nil, student?.latitude != nil, student?.longitude != nil, student?.objectId != nil {
                    
                    OTMClient.Student.PostedLocation = true
                    OTMClient.Student.OTMStudentObjectId = (student?.objectId)!
                    performUIUpdatesOnMain {
                        self.overWriteAlert()
                    }
                } else {
                    OTMClient.Student.PostedLocation = false
                    performUIUpdatesOnMain {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") as! EnterLocationViewController
                        performUIUpdatesOnMain {
                            
                            self.navigationController?.pushViewController(controller, animated: true)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func overWriteAlert() {
        let message = "User \"\(OTMClient.Student.OTMStudentFirstName) \(OTMClient.Student.OTMStudentLastName)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Locaiton?"
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "OverWrite", style: .default) { (action) in

            let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") as! EnterLocationViewController
            
            performUIUpdatesOnMain {
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
                
            
        }
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
