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
    
    var otmStudents: [OTMStudent] = [OTMStudent]()
    
    @IBOutlet weak var mapView: MKMapView!

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

// **** Here is where I need to create the call Parse for the create an array of students. ****
        
        OTMClient.sharedInstance().getStudentLocations { (students, error) in
            if students != nil {
                performUIUpdatesOnMain {
                    self.otmStudents = students!
                    
                    // MKPointAnnotation student in students
                    var annotations = [MKPointAnnotation]()
                    
                    for student in self.otmStudents {
                        
                        // Notice that the float values for CLLocationDegree values.
                        let lat: CLLocationDegrees
                        let long: CLLocationDegrees
                        let coordinate: CLLocationCoordinate2D
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        
                        let first = student.firstName ?? "BLANK"
                        let last = student.lastName ?? "BLANK"
                        let mediaURL = student.mediaURL ?? "https://www.udacity.com"
                        
                        if let latitude = student.latitude, let longitude = student.longitude{
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
                    }
                    
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.addAnnotations(annotations)
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
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                
            }
        }
    }
}


