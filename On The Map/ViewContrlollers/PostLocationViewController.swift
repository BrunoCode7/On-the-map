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
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = Link
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func finishButton(_ sender: Any) {
        let userUniqueKey = UserDefaults.standard.string(forKey: "userUniqueKey")
        let userFirstName = UserDefaults.standard.string(forKey: "userFirstName")
        let userLastName = UserDefaults.standard.string(forKey: "userLastName")
//        ParseClient.getMethodForSingleStudentLocation(studentUniqueID: userUniqueKey!) { (response, errorCode) in
//            if response != nil{
//                print("will update data")
//                //already have data should update
//                ParseClient.putMethodForStudentLocation(objectId: (response?.results[0].objectId)!, uniqueId: userUniqueKey!, firstName: userFirstName!
//                    , lastName: userLastName!, mapString: self.Address, mediaURL: self.Link, latitdude: self.location.coordinate.latitude, longitude: self.location.coordinate.longitude, completionHandlerForUpdatingSingleStudentLocation: { (response, eroorCode) in
//                        if response != nil{
//                            print("Data updated")
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                        else{
//                            self.showSimpleAlert("Error", "Failed posting data, please check your connection")
//                        }
//                })
//            }else{
//                print("will post data for the first time")
                //first time posting data
                ParseClient.postMethodForStudentLocation(uniqueId: userUniqueKey!, firstName:  userFirstName!, lastName: userLastName!, mapString: self.Address, mediaURL: self.Link, latitdude: self.location.coordinate.latitude, longitude: self.location.coordinate.longitude, completionHandlerForSingleStudentLocation: { (response, errorCode) in
                    if response != nil{
                        print("Data posted")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.showSimpleAlert("Error", "Failed posting data, please check your connection")
                    }
                })
            }
//        }
//    }
    
    
    

    //helper function to show simple alerts
    private func showSimpleAlert(_ title:String, _ messege:String){
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default){(action)in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    }

