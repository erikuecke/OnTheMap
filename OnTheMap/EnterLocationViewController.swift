//
//  EnterLocationViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/19/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// Validation URL
extension String {
    
    func isValidURL() -> Bool {
        
        if let url = URL(string: self) {
            
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false 
    }
}

class EnterLocationViewController: UIViewController, UITextFieldDelegate {
    
    // Acitivity indicator
    var activityIndicator = UIActivityIndicatorView()
    
    // 1) link everythings
    // 2) Set up text field delegate
    // 3) initiate text field delegaet
    // 4) set up initial steps of action
    // 5) get the lat long of the student for postin gor putting
    // 6) if locatonpost true put if false post.
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var debugTextView: UITextView!

    
    override func viewDidLoad() {
        locationTextField.text = ""
        websiteTextField.text = ""
        debugTextView.text = ""
        
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    @IBAction func findLocationAddURL(_ sender: Any) {
        
        // locationtextfield
        if locationTextField.text != nil || locationTextField.text != "" {
            OTMClient.Student.OTMStudentAddress = locationTextField.text!
        } else {
            performUIUpdatesOnMain {
                self.showAddressError()
            }
        }
        
        // websiteTExtfield
        if websiteTextField.text != nil, websiteTextField.text != "", (websiteTextField.text?.isValidURL())! {
            OTMClient.Student.OTMStudenURL = websiteTextField.text!
        } else {
            performUIUpdatesOnMain {
                self.showWebError()
            }
        }
        
        let annotation = MKAnnotation()
        // Start Geocoder
        let geocoder = CLGeocoder()
        
        // Start Animation process
        view.alpha = CGFloat(0.75)
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        
        
        
        if OTMClient.Student.PostedLocation {
            // Put Method for location
        } else {
            // Post method for location
        }
    }
    
    // Text Field Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
    
    // Address error function
    func showAddressError() {
        let alert = UIAlertController(title: "", message: "There was problem with your address entry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    func showWebError() {
        let alert = UIAlertController(title: "", message: "There was problem with your web address entry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
