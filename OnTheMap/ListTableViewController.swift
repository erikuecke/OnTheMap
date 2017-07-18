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
        
        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getStudentLocations { (students, error) in
            if let students = students {
                OTMClient.Students.OTMStudentsArray = students
                performUIUpdatesOnMain {
                    self.listTableView.reloadData()
                }
            } else {
                print(error ?? "empty errors")
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
        let student = OTMClient.Students.OTMStudentsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as UITableViewCell!
        
        // Set Cell defaults
        cell?.textLabel?.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
        cell?.imageView?.image = UIImage(named: "icon_pin")
        cell?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell?.detailTextLabel?.text = (student.mediaURL ?? "https://udacity.com")
        
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMClient.Students.OTMStudentsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        let otmStudentInfo = OTMClient.Students.OTMStudentsArray[indexPath.row]
        if let linkToOpen = URL(string: otmStudentInfo.mediaURL!) {
            UIApplication.shared.open(linkToOpen, options: [:])
            
        }
    }
    
    
    
}



