//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/11/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewController: UIViewController {
    
    // MARK: Properties
//    var otmStudents: [OTMStudent] = [OTMStudent]()
    
    // MARK: Outlets
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performUIUpdatesOnMain {
            OTMClient.Animations.beginActivityIndicator(view: self.view)
        }
        OTMClient.sharedInstance().getStudentLocations { (students, errorString) in
            if let students = students {
                OTMStudents.Students.OTMStudentsArray = students
                performUIUpdatesOnMain {
                    self.listTableView.reloadData()
                    OTMClient.Animations.endActivityIndicator(view: self.view)
                }
            } else {
                self.errorAlert(errorString!)
            }
        }
    }
    
    // MARK: Logout
    
    func logout() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource 

extension ListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get cell type
        let cellID = "ListTableCell"
        let student = OTMStudents.Students.OTMStudentsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as UITableViewCell!
        
        // Set Cell defaults
        cell?.textLabel?.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
        cell?.imageView?.image = UIImage(named: "icon_pin")
        cell?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell?.detailTextLabel?.text = (student.mediaURL ?? "https://udacity.com")
        
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMStudents.Students.OTMStudentsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performUIUpdatesOnMain {
            OTMClient.Animations.beginActivityIndicator(view: self.view)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
        let otmStudentInfo = OTMStudents.Students.OTMStudentsArray[indexPath.row]
        
        if let linkToOpen = URL(string: otmStudentInfo.mediaURL!) {
            
            if  UIApplication.shared.canOpenURL(linkToOpen) {
                performUIUpdatesOnMain {
                    OTMClient.Animations.endActivityIndicator(view: self.view)
                    UIApplication.shared.open(linkToOpen, options: [:])
                }
            } else {
                errorAlert("URL Invalid")
            }
            
            
        }
    }
    // URL Error alert
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
  
}



