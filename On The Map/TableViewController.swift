//
//  TableViewController.swift
//  On The Map
//
//  Created by Baraa Hesham on 4/24/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import UIKit
struct cellData {
    
    let image:UIImage?
    let user:String?
    let url:String?
}
class TableViewController: UITableViewController {
    
    @IBOutlet var myTable: UITableView!
    var globalResponse = [Studentlocation]()
    var data = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
        getAndShowStudentsLocation()
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let data = self.globalResponse[(indexPath as NSIndexPath).row]
        if let firstName=data.firstName, let lastName = data.lastName{
            cell.studentName.text = "\(firstName) \(lastName)"
        }else{
            cell.studentName.text = ""
        }
        
        if let studentURL=data.mediaURL{
            cell.studentURL.text = studentURL
        }else{
            cell.studentURL.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalResponse.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.globalResponse[(indexPath as NSIndexPath).row]
        
        let app = UIApplication.shared
        if let toOpen = data.mediaURL {
            if toOpen.contains("http://") || toOpen.contains("https://"){
                app.openURL(URL(string: toOpen)!)}else{
                
                showSimpleAlert("Invalid URL", "The URL should contains (https://) or (http://)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAndShowStudentsLocation()
    }
    
    private func getAndShowStudentsLocation(){
        
        ParseClient.getMethodForStudentsLocation(){
            (response,errorCode) in
            DispatchQueue.main.async {
                if response != nil {
                    self.globalResponse = (response?.results)!
                    self.myTable.reloadData()
                }else{
                    self.showSimpleAlert("Error", "Please check your internet connection")
                }
            }
        }
    }
    
    
    
    
    @IBAction func refreshTableData(_ sender: Any) {
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
            
        }    }
    
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
