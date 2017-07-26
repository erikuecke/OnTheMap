//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/12/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class OTMClient: NSObject  {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    

    
    // authentication state

    var sessionKey: String? = nil
    var userID: Int? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ method: String, parameters: [String: AnyObject]?, host: String, path: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: otmURLFromParameters(parameters, withPathExtension: method, host: host, path: path))
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandlerForGET(nil, error! as NSError)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Log In Credentials were incorrect please try again.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task

    }
    
    // DELETE SESSION
    
    
    
    
    // Mark: Post
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject]?, host: String, path: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: otmURLFromParameters(withPathExtension: method, host: host, path: path))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("THERE WAS AN ERROR")
                completionHandlerForPOST(nil, error! as NSError)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Log In Credentials were incorrect please try again.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: GET
    
    func parseTaskForGETMethod(_ method: String, parameters: [String: AnyObject]?, host: String, path: String, completionHandlerForParseGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: otmURLFromParameters(parameters, withPathExtension: method, host: host, path: path))
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParseGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandlerForParseGET(nil, error! as NSError)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Unable to access information requested")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
//            let range = Range(5..<data.count)
//            let newData = data.subdata(in: range) /* subset response data! */
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParseGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    // MARK: PARSE POST
    
    func parseTaskForPostPutMethod(_ method: String, parameters: [String: AnyObject]?, host: String, path: String, httpMethod: String,completionHandlerForParsePOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: otmURLFromParameters(parameters, withPathExtension: method, host: host, path: path))
        request.httpMethod = httpMethod
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(OTMClient.Student.OTMStudentKey)\", \"firstName\": \"\(OTMClient.Student.OTMStudentFirstName)\", \"lastName\": \"\(OTMClient.Student.OTMStudentLastName)\",\"mapString\": \"\(OTMClient.Student.OTMStudentMapString)\", \"mediaURL\": \"\(OTMClient.Student.OTMStudenURL)\",\"latitude\": \(OTMClient.Student.OTMStudentLatitude), \"longitude\": \(OTMClient.Student.OTMStudentLongitude)}".data(using: String.Encoding.utf8)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParsePOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            //            let range = Range(5..<data.count)
            //            let newData = data.subdata(in: range) /* subset response data! */
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParsePOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }

    
    // LOGOUT BUTTON
    
    
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Helpers
    
    // Substitue the key for the value that is conatined within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "\(key)") != nil {
            return method.replacingOccurrences(of: "\(key)", with: value)
        } else {
            return nil
        }
    }
    
    // Given raw JSON, return a usable Foundaton object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: [String:AnyObject]! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject, nil)
    }
    
    // create a URL from parameters
    private func otmURLFromParameters(_ parameters: [String:AnyObject]? = nil, withPathExtension: String? = nil, host: String, path: String) -> URL {
        
        var components = URLComponents()
        components.scheme = OTMClient.Constansts.Scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        
        return components.url!
    }
}
