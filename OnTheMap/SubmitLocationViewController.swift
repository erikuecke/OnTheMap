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
    
    override func viewDidLoad() {
        navigationItem.title = "Submit locaiton"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAddEnterLocation))
        
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

         // For whether it is being over written or not.
        if OTMClient.Student.PostedLocation  {
            // Put Method for location if overwriting.
            OTMClient.sharedInstance().putStudentLocation(completionHandlerForPutStudent: { (success, errorString) in
                if success {
                    performUIUpdatesOnMain {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    print(errorString!)
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
                }
            }
        }
    }
    
    
    
}
