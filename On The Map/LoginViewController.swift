//
//  ViewController.swift
//  On The Map
//
//  Created by Baraa Attia on 4/10/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickSignIn(_ sender: Any) {
        UdacityClient.taskForPOSTMethod(username: emailTextField.text!, password: passwordTextField.text!) { (loginSession, error) in
            DispatchQueue.main.async {
                  UdacityClientConstants.userLoginSession = loginSession
    
                print("Task completed")
            }
        }
    }
}

