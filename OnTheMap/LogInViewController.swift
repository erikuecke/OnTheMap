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
        
        // For Textfield/Keyboard
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
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
                        self.displayError(errorString)
                    }
                }
            }
        }
        
        
    }
    
    // Sign Up for account
    @IBAction func signUpPressed(_ sender: Any) {
    }
    
    // Complete login and segue to first controller
    private func completeLogIn() {
        self.debugTextLabel.text = ""
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        print("keyboardWillShow")
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
//            logoImageView.isHidden = true
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        print("keyboardWillHide")
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
//            logoImageView.isHidden = false
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        print("keyboardDidShow")
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        print("keyboardDidHide")
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
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









