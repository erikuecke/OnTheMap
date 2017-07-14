//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/12/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
    
    // MARK: Authentication (GET) Methods
    
    /*
     Steps for authentification...
     
     Step 1: Create Session ID
     Step 2:
     */
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // Chain completion handlers for each requset so that they run one after the other.
        postUdacitySession() { (success, sessionKey, errorString) in
            
            if success {
                
                // We have the sessionKey
                self.sessionKey = sessionKey
                
                // Get the user Data
                self.getUdacityUser(sessionKey!, completionHandlerForUserData: { (success, firstAndLast, errorString) in
                    
                    self.firstName = firstAndLast?[0]
                    self.lastName = firstAndLast?[1]
                    print(self.firstName! + " " + self.lastName!)
                    
                })
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    
    //MARK: GETTING SESSIONKEY
    private func postUdacitySession(completionHandlerForPostSession: @escaping (_ success: Bool, _ sessionKey: String?, _ errorString: String?) -> Void) {
    
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */

        
        let jsonBody = "{\"udacity\": {\"username\": \"\(OTMClient.User.Username)\", \"password\": \"\(OTMClient.User.Password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(OTMClient.UdacityMethods.PostSession, parameters: nil, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForPostSession(false, nil, "Login Failed (Session ID).")
                
            } else {
                if let account = results?[OTMClient.JSONResponseKeys.UdacityAccount] as? [String: AnyObject],
                let sessionKey = account[OTMClient.JSONResponseKeys.UdacitySessionKey] as? String {
                    completionHandlerForPostSession(true, sessionKey, nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.UdacitySessionKey) in \(results!)")
                    completionHandlerForPostSession(false, nil, "Login Failed (Session ID).")
                }
            }
        }
    }
    
    // MARK: GET USER DATA
    
    func getUdacityUser(_ sessionKey: String, completionHandlerForUserData: @escaping (_ success: Bool, _ firstAndLast: [String]?, _ errorString: String?) -> Void) {
        
        // 1. Specify method parameters.
        var mutableMethed: String = OTMClient.UdacityMethods.UserData
        mutableMethed = substituteKeyInMethod(mutableMethed, key: "<user_id>", value: sessionKey)!
        var firstAndLast = [String]()
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethed, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserData(false, nil, "Login Failed (getUdacityUser).")
            } else {
                if let user = results?[OTMClient.JSONResponseKeys.UdacityUser] as? [String: AnyObject] {
                    
                    firstAndLast.append(user[OTMClient.JSONResponseKeys.UdacityFirstName] as! String)
                    firstAndLast.append(user[OTMClient.JSONResponseKeys.UdacityLastName] as! String)
                    completionHandlerForUserData(true, firstAndLast, nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.UdacityUser) in \(results!)")
                    completionHandlerForUserData(false, nil, "Login Failed (getUdacityUser).")
                }
            }
        }
        
    }
    
    
}
