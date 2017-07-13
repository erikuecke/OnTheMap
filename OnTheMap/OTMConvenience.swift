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
                self.sessionKey = sessionKey
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    private func postUdacitySession(completionHandlerForPostSession: @escaping (_ success: Bool, _ sessionKey: String?, _ errorString: String?) -> Void) {
    
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [TMDBClient.ParameterKeys.RequestToken: requestToken!]
        
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
    
    
    
}
