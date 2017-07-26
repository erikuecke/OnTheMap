//
//  OTMStudents.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/26/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class OTMStudents: NSObject {
    
    // PARSED STUDENTS ARRAY OF STRUCTS
    struct Students {
        static var OTMStudentsArray: [OTMStudent] = []
    }
    
    
    // MARK: Shared Instance
    static let sharedInstace = Students()
    
    

}
