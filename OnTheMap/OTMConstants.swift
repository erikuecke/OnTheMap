//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/12/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation

extension OTMClient {
    
    struct User {
        static var Username = ""
        static var Password = ""
    }
    
    
    struct Constansts {
        
        // MARK: URLs
        static let UdacityScheme = "https"
        static let UdacityHost = "www.udacity.com"
        static let UdacityPath = "/api"
    }
    // MARK: Methods
    struct UdacityMethods {
        
        // MARK: UdacityMethod
        static let PostSession = "/session"
        static let UserData = "/users/<user_id>"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Udacity
        static let UdacityAccount = "account"
        static let UdacitySessionKey = "key"
    }
}
