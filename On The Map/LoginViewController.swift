//
//  ViewController.swift
//  On The Map
//
//  Created by Baraa Attia on 4/10/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit
import SafariServices
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSignIn(_ sender: Any) {
        UdacityClient.taskForPOSTMethod(username: emailTextField.text!, password: passwordTextField.text!) { (loginSession, errorCode) in
            DispatchQueue.main.async {
                if (loginSession?.account.registered) != nil{
                    self.performSegue(withIdentifier: "signedIn", sender: self)
                    UserDefaults.standard.set(loginSession?.account.key, forKey: "userUniqueKey")
                    self.getUserData()
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
    @IBAction func signUpButton(_ sender: Any) {
        // open safary on Udacity sign up page
        let svc = SFSafariViewController(url: URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!)
        present(svc, animated: true, completion: nil)
    }
    private func getUserData() {
        let userUniqueKey = UserDefaults.standard.string(forKey: "userUniqueKey")
        UdacityClient.taskForGETMethod(userId: userUniqueKey!) { (user, errorCode) in
            if user != nil{
                print("we got user data = \(user)")
                UserDefaults.standard.set(user?.first_name, forKey: "userFirstName")
                UserDefaults.standard.set(user?.last_name, forKey: "userLastName")
                
            }else{
                print("failed to get user data, error code = \(errorCode)")
            }
        }
    }    //helper function to show simple alerts
    private func showSimpleAlert(_ title:String, _ messege:String){
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default){(action)in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

