//
//  MapViewController.swift
//  On The Map
//
//  Created by Baraa Hesham on 4/24/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        getAndShowStudentsLocation()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func refreshMap(_ sender: Any) {
        getAndShowStudentsLocation()
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        UdacityClient.taskForDELETEMethod(){(deleteSession,errorCode)in
            
            DispatchQueue.main.async {
                if (deleteSession) != nil{
                    self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
                }else{
                    if errorCode==nil{
                        print("problem connecting to server")
                        //problem connecting to server
                        self.showSimpleAlert("Error", "Problem connecting to server")
                    }else if errorCode == 403{
                        print("wrong credintials")
                        //wrong credintials
                        self.showSimpleAlert("Error", "Wrong credintials")
                    }else if errorCode == 400{
                        print("Empty username and PW textFields")
                        self.showSimpleAlert("Error", "Please enter your Email & password")
                    }
                }
                print("Task completed")
            }
            
        }
    }
    
    //helper function to show simple alerts
    private func showSimpleAlert(_ title:String, _ messege:String){
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default){(action)in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getAndShowStudentsLocation(){

        ParseClient.getMethodForStudentsLocation(){
            (response,errorCode) in
            DispatchQueue.main.async {
                if response != nil {
                    self.showLocationsOnMap(locations: response!, theMapview: self.mapView)
                }else{
                    self.showSimpleAlert("Error", "Please check your internet connection")
                }
            }
        }
    }
    
    private func showLocationsOnMap(locations:locationResponse, theMapview:MKMapView){
        let locations = locations.results
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            let lat = CLLocationDegrees(exactly: location.latitude!)
            let long = CLLocationDegrees(exactly: location.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            let annotation = MKPointAnnotation()

            if let firstName = location.firstName,let lastName = location.lastName{
                            annotation.title = "\(firstName) \(lastName)"
            }else{
                annotation.title = ""
            }
            
            if let mediaURL = location.mediaURL{
                annotation.subtitle = mediaURL
            }else{
                annotation.subtitle = ""

            }
            
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
            
        }
        if theMapview.annotations.count != 0 {
            print("There are some annotations")
            theMapview.removeAnnotations(theMapview.annotations)
        }else{
            print("There is no annotations")
            theMapview.addAnnotations(annotations)
        }
        theMapview.addAnnotations(annotations)

    }

}
