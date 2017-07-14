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
        static let Scheme = "https"
        static let UdacityHost = "www.udacity.com"
        static let UdacityPath = "/api"
        
    }
    // MARK: Methods
    struct UdacityMethods {
        
        // MARK: UdacityMethod
        static let PostSession = "/session"
        static let UserData = "/users/<user_id>"
    }
    
    struct PARSEMethods {
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Udacity
        static let UdacityAccount = "account"
        static let UdacitySessionKey = "key"
        static let UdacityUser = "user"
        static let UdacityLastName = "last_name"
        static let UdacityFirstName = "first_name"
        
        // MARK: PARSE
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
    }
}
