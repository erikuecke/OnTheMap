//
//  OTMStudent.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/14/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation

struct OTMStudent {
    
    // MARK: Properties
    
    let latitude: Double?
    let longitude: Double?
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let uniquekey: String?
    let objectId: String?
    let mapString: String?
    
    // MARK: Initializers
    
    // Construct a OTMStudentfrom a dictionary
    init(dictionary: [String: AnyObject]) {
        latitude = dictionary[OTMClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[OTMClient.JSONResponseKeys.Longitude] as? Double
        firstName = dictionary[OTMClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[OTMClient.JSONResponseKeys.LastName] as? String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.MediaURL] as? String
        uniquekey = dictionary[OTMClient.JSONResponseKeys.UniqueKey] as? String
        objectId = dictionary[OTMClient.JSONResponseKeys.ObjectID] as? String
        mapString = dictionary[OTMClient.JSONResponseKeys.MapString] as? String
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [OTMStudent] {
        
        var students = [OTMStudent]()
        
        // Iterate through array of dicts each student is a dictionary
        for result in results {
            students.append(OTMStudent.init(dictionary: result))
        }
//        print("STUDENTS ARRAY")
//        print(students)
        return students
    }
}
