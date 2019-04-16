//
//  UdacityClient.swift
//  On The Map
//
//  Created by Baraa Attia on 4/11/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import Foundation

class UdacityClient{
    
    
    
    static func taskForPOSTMethod(username:String, password: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! it is = \(String(describing: (response as! HTTPURLResponse).statusCode))")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            print("this is data = \(String(describing: data)) and this is response = \(String(describing: response))")
            let range = Range(5..<data.count)
            
            let newData = data.subdata(in: range)
            
            let parsedResult: AnyObject!
            
            do {
                
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! AnyObject
                completionHandlerForPOST(parsedResult,nil)
            } catch {
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
}
