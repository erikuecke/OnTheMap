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
        
//        1) Get specific student location request for AddStudentLocation button.
//        2) Compare with Session First and Last name to see if already entered.
//        3) If Student already exists, present alert modal to see if wants to overwrite.
//        4) If yes remove modal, segue to enterlocation view.
//        5) if cancel remove modal stay on present view.

        
//        I) 8. Parse Api: Geting a student locatoin
//        a) unsuccessful - segue to enter location. - 9. Posting a student location.
//        b) Successful
//          - Get object id for 10.PUTing Student location.
//          - Present modal to see if wants to overwrite. if yes segue -
        
//        II) On EnterLocationViewController
//          a) If NOT overwriting 9. Posting a student location
//          b) If Overwriting 10. Parse API - PUTing Student location.
        
        OTMClient.sharedInstance().getOneStudentLocation { (success, student, errorString) in
            if success {
                if student != nil, student?.latitude != nil, student?.longitude != nil {
                    
                    OTMClient.Student.PostedLocation = true
                    performUIUpdatesOnMain {
                        self.overWriteAlert()
                    }
                } else {
                    OTMClient.Student.PostedLocation = false
                    performUIUpdatesOnMain {
                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") {
                            self.present(controller, animated: true, completion: nil)
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

            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") {
                self.present(controller, animated: true, completion: nil)
                
            }
        }
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
