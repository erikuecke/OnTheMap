//
//  PinMapViewController.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/11/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinMapViewController: UIViewController, MKMapViewDelegate {
    
//    var otmStudents: [OTMStudent] = [OTMStudent]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OTMClient.Animations.beginActivityIndicator(view: self.view)

        mapView.removeAnnotations(mapView.annotations)
        
        
        // MKPointAnnotation student in students
        var annotations = [MKPointAnnotation]()
        
        OTMClient.sharedInstance().getStudentLocations { (students, errorString) in
            if errorString == nil {
                if let students = students {
                    OTMStudents.Students.OTMStudentsArray = students
                    
                    for student in OTMStudents.Students.OTMStudentsArray {
                        
                        // Notice that the float values for CLLocationDegree values.
                        let lat: CLLocationDegrees
                        let long: CLLocationDegrees
                        let coordinate: CLLocationCoordinate2D
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        
                        let first = student.firstName ?? "BLANK"
                        let last = student.lastName ?? "BLANK"
                        let mediaURL = student.mediaURL ?? "https://www.udacity.com"
                        
                        let latitude = student.latitude ?? 0
                        let longitude = student.longitude ?? 0
                        
                        lat = CLLocationDegrees(latitude)
                        long = CLLocationDegrees(longitude)
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                        
                    }
                    
                    performUIUpdatesOnMain {
                        
                        // When the array is complete, we add the annotations to the map.
                        self.mapView.addAnnotations(annotations)
                        OTMClient.Animations.endActivityIndicator(view: self.view)
                    }
                }
            } else {
                
                performUIUpdatesOnMain {
                    OTMClient.Animations.endActivityIndicator(view: self.view)
                    self.errorAlert(errorString!)
                }
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
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
    
    
    // This delegate method to respond to taps.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let linkToOpen = URL(string: toOpen) {
                    
                    if  UIApplication.shared.canOpenURL(linkToOpen) {
                        performUIUpdatesOnMain {
                            OTMClient.Animations.endActivityIndicator(view: self.view)
                            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                        }
                    } else {
                        errorAlert("URL Invalid")
                    }
                }
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


