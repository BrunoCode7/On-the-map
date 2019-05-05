//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Baraa Hesham on 5/3/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var location = CLLocation()
    var Link = String()
    var Address = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
            print(location)
            print(Link)
        var annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.subtitle = Address
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.addAnnotation(annotation)
        mapView.setRegion(coordinateRegion, animated: true)
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func fenishButton(_ sender: Any) {
        let userUniqueKey = UserDefaults.standard.string(forKey: "userUniqueKey")
        ParseClient.getMethodForSingleStudentLocation(studentUniqueID: userUniqueKey!) { (response, errorCode) in
            if response != nil{
                //already have data should update
                
            }else{
                //first time posting data
                
            }
        }
    }
    
    }

