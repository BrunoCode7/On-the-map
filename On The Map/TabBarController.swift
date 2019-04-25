//
//  TabBarController.swift
//  On The Map
//
//  Created by Baraa Hesham on 4/25/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import Foundation
import UIKit
class TabBarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn(){
            return
        }else{
            performSegue(withIdentifier: "signIn", sender: self)
        }
    }
    
    
    private func isLoggedIn()->Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
