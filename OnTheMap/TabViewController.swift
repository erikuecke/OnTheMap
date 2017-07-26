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
        
        performUIUpdatesOnMain {
            OTMClient.Animations.beginActivityIndicator(view: self.view)
        }

        // Get the updated data
        OTMClient.sharedInstance().getStudentLocations { (students, errorString) in
            if errorString == nil {
                OTMStudents.Students.OTMStudentsArray = students!
                
                performUIUpdatesOnMain {
                    OTMClient.Animations.endActivityIndicator(view: self.view)
                }
            } else {
                performUIUpdatesOnMain {
                    OTMClient.Animations.endActivityIndicator(view: self.view)
                    self.errorAlert(errorString!)
                    
                }
            }
        }
    }

    @IBAction func addStudentLocation(_ sender: Any) {
        
        performUIUpdatesOnMain {
            OTMClient.Animations.beginActivityIndicator(view: self.view)
        }

        // Get single student locatino if available.
        OTMClient.sharedInstance().getOneStudentLocation { (success, student, errorString) in
            if success {
                if student != nil, student?.latitude != nil, student?.longitude != nil, student?.objectId != nil {
                    
                    OTMClient.Student.PostedLocation = true
                    OTMClient.Student.OTMStudentObjectId = (student?.objectId)!
                    performUIUpdatesOnMain {
                        OTMClient.Animations.endActivityIndicator(view: self.view)
                        self.overWriteAlert()
                    }
                } else {
                    OTMClient.Student.PostedLocation = false
                    performUIUpdatesOnMain {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") as! EnterLocationViewController
                        performUIUpdatesOnMain {
                            OTMClient.Animations.endActivityIndicator(view: self.view)
                            self.navigationController?.pushViewController(controller, animated: true)
                            
                        }
                    }
                }
            }
        }
        
    }
    // MARK: ALERTS
    
    // Overwrite alert
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
