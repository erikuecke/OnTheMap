//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/12/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var keyboardOnScreen = false
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        debugTextLabel.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
        
    }
    
    // MARK: Actions
    
    // Login Pressed
    @IBAction func loginPressed(_ sender: Any) {
        
        userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty"
        } else {
            OTMClient.User.Username = emailTextField.text!
            OTMClient.User.Password = passwordTextField.text!
            
            OTMClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogIn()
                    } else {
                        self.errorAlert(errorString!)
//                        print(errorString!)

                    }
                }
            }
        }
        
        
    }
    
    // Sign Up for account
    @IBAction func signUpPressed(_ sender: Any) {
        performUIUpdatesOnMain {
            OTMClient.Animations.beginActivityIndicator(view: self.view)
            if let linkToOpen = URL(string: "https://www.udacity.com/account/auth#!/signup") {
                
                    OTMClient.Animations.endActivityIndicator(view: self.view)
                
                UIApplication.shared.open(linkToOpen, options: [:])
                
            }
        }
    }
    
    // Complete login and segue to first controller
    private func completeLogIn() {
        self.debugTextLabel.text = ""
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        performUIUpdatesOnMain {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    
   @IBAction func userDidTapView(_ sender: AnyObject) {
   resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}









