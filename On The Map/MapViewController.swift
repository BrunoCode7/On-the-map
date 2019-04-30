//
//  MapViewController.swift
//  On The Map
//
//  Created by Baraa Hesham on 4/24/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

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
    @IBAction func signOutButton(_ sender: Any) {
        UdacityClient.taskForDELETEMethod(sessionId: (UdacityClientConstants.userLoginSession!.session.id)){(deleteSession,errorCode)in
            
            DispatchQueue.main.async {
                if (deleteSession) != nil{
                    self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
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

}
