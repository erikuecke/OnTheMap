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
        static let ParsePath = "/parse"
        static let ParseHost = "parse.udacity.com"
        
    }
    // MARK: Methods
    struct UdacityMethods {
        
        // MARK: UdacityMethod
        static let PostSession = "/session"
        static let UserData = "/users/<user_id>"
    }
    
    struct PARSEMethods {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
    struct ParameterKeys {
        static let Limit = "limit" // 100
        static let Skip = "skip" // 400
        static let Order = "order" // -udateAt
        static let Where = "where" // {"uniqueKey":"1234"}
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Udacity
        static let UdacityAccount = "account"
        static let UdacityUserKey = "key"
        static let UdacityUser = "user"
        static let UdacityLastName = "last_name"
        static let UdacityFirstName = "first_name"
        
        // MARK: PARSE
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let UniqueKey = "uniqueKey"
        static let ObjectID = "objectId"
        static let MapString = "mapString"
        
        // MARK: RESULTS
        static let Results = "results"
    }
    
    // PARSED STUDENTS ARRAY OF STRUCTS
    struct Students {
        static var OTMStudentsArray: [OTMStudent] = []
    }
    
    struct Student {
        static var OTMStudentKey = String()
        static var OTMStudentFirstName = String()
        static var OTMStudentLastName = String()
        static var PostedLocation = Bool()
        static var OTMStudentAddress = String()
        static var OTMStudenURL = String()
    }
    
    
    
}
