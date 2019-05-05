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
    private var gLink = String()
    private var gLocation = CLLocation()
    private var gAddress = String()

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var locationEditText: UITextField!
    
    @IBOutlet weak var linkEditText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading(isLoading: false)
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
        isLoading(isLoading: true)
        guard let address = locationEditText.text else{
            showSimpleAlert("Error", "Please enter your address")
            return
        }
        guard let Link = linkEditText.text else{
            showSimpleAlert("Error", "Please enter your link")
            return
        }
        
        if Link == "" || address == ""{
            showSimpleAlert("Error", "Please fill all fields")
        } else{
            geocoder.geocodeAddressString(address) { (placemarkers, error) in
                if let error = error{
                    self.isLoading(isLoading: false)
                    self.showSimpleAlert("Error", "Failed to geocode the address")
                    print(error.localizedDescription)
                }else{
                    self.isLoading(isLoading: false)
                    var location:CLLocation?
                    if let placemarks = placemarkers, placemarks.count > 0 {
                        location = placemarks.first?.location
                    }
                    if let location = location {
                        self.gLocation=location
                        self.gLink = Link
                        self.gAddress = address
                    self.performSegue(withIdentifier: "findLocation", sender: self)
                    }else{
                        self.showSimpleAlert("Error", "No matching location found")
                    }
                }
            }        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation"{
            let controller = segue.destination as! PostLocationViewController
            controller.Link = gLink
            controller.location = gLocation
            controller.Address = gAddress
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
    
    private func isLoading(isLoading:Bool){
        if isLoading{
            loadingView.isHidden = false
        }else{
            loadingView.isHidden = true
        }
    }
}
