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
        let _ = taskForPOSTMethod(OTMClient.UdacityMethods.PostSession, parameters: nil, host: OTMClient.Constansts.UdacityHost , path: OTMClient.Constansts.UdacityPath, jsonBody: jsonBody) { (results, error) in
            
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
    
    // DELETING USER SESSION 
    
    func deleteUdacitySession(completionsHandlerForDeleteSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
               completionsHandlerForDeleteSession(false, "Log out failed")
            } else {
                completionsHandlerForDeleteSession(true, nil)
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print("\(String(describing: newData))")
            
        }
        task.resume()
    }
    
    // MARK: GET USER DATA
    
    func getUdacityUser(_ sessionKey: String, completionHandlerForUserData: @escaping (_ success: Bool, _ firstAndLast: [String]?, _ errorString: String?) -> Void) {
        
        // 1. Specify method parameters.
        var mutableMethed: String = OTMClient.UdacityMethods.UserData
        mutableMethed = substituteKeyInMethod(mutableMethed, key: "<user_id>", value: sessionKey)!
        var firstAndLast = [String]()
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethed, parameters: nil, host: OTMClient.Constansts.UdacityHost , path: OTMClient.Constansts.UdacityPath) { (results, error) in
            
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
    
    func getStudentLocations(completionHandlerForGetLocations: @escaping (_ results: [OTMStudent]?, _ error: NSError?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [OTMClient.ParameterKeys.Limit: "100"]
        
        /* 2. Make the request */
        let _ = parseTaskForGETMethod(OTMClient.PARSEMethods.StudentLocation, parameters: parameters as [String : AnyObject], host: OTMClient.Constansts.ParseHost, path: OTMClient.Constansts.ParsePath) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetLocations(nil, error)
            } else {
                
                if let results = results?[OTMClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    let students = OTMStudent.studentsFromResults(results)
                    
                    completionHandlerForGetLocations(students, nil)
                } else {
                    completionHandlerForGetLocations(nil, NSError(domain: "getStudent location parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    

}
