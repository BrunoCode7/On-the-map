//
//  FindLocationViewController.swift
//  On The Map
//
//  Created by Baraa Hesham on 5/3/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    var geocoder = CLGeocoder()

    @IBOutlet weak var locationEditText: UITextField!
    
    @IBOutlet weak var linkEditText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocationButton(_ sender: Any) {
        guard let address = locationEditText.text else{
            showSimpleAlert("Error", "Please enter your address")
            return
        }
        guard let Link = linkEditText.text else{
            showSimpleAlert("Error", "Please enter your address")
            return
        }
        geocoder.geocodeAddressString(address) { (placemarkers, error) in
            if let error = error{
                self.showSimpleAlert("Error", "Failed to geocode the address")
                print(error.localizedDescription)
            }else{
                var location:CLLocation?
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                if let location = location {
                    print(location.coordinate)
                }else{
                    self.showSimpleAlert("Error", "No matching location found")
                }
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
}
