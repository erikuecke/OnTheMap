//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/20/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
    
    // code
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Submit location"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelAddEnterLocation))
     
        
        // Set up MapView
        let annotation = OTMClient.Student.OTMStudentAnnotation
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let location = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
       
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
        
    }
    
    // right callout accessory view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    // Cancel adding and entersing button method
    func cancelAddEnterLocation() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Submitting location new or not.
    @IBAction func submitLocation(_ sender: Any) {
        performUIUpdatesOnMain {
            OTMClient.Animations.beginActivityIndicator(view: self.view)
        }
         // For whether it is being over written or not.
        if OTMClient.Student.PostedLocation  {
            // Put Method for location if overwriting.
            OTMClient.sharedInstance().putStudentLocation(completionHandlerForPutStudent: { (success, errorString) in
                if success {
                    performUIUpdatesOnMain {
                        OTMClient.Animations.endActivityIndicator(view: self.view)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    performUIUpdatesOnMain {
                        OTMClient.Animations.endActivityIndicator(view: self.view)
                        self.failedToSubmitAlert(errorString!)
            
                    }
                   
                }
            })
        } else {
            // Post Method for student if new
            OTMClient.sharedInstance().postStudentLocation { (success, objectId, errorString) in
                if success {
                    if objectId != nil {
                        OTMClient.Student.OTMStudentObjectId = objectId!
                        performUIUpdatesOnMain {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                } else {
                    performUIUpdatesOnMain {
                        OTMClient.Animations.endActivityIndicator(view: self.view)
                        self.failedToSubmitAlert(errorString!)
                        
                    }
                }
            }
        }
    }
    
    // Failed Submission
    func failedToSubmitAlert(_ errorString: NSError) {
        let message = "Your submission failed to post because: \(errorString.localizedDescription), please check the information you entered and try again."
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Check Entry", style: .default) { (action) in
            
            
            performUIUpdatesOnMain {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }  

}
