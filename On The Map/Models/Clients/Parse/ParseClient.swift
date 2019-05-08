//
//  ParseClient.swift
//  On The Map
//
//  Created by Baraa Hesham on 5/1/19.
//  Copyright © 2019 Baraa Attia. All rights reserved.
//

import Foundation
struct locationResponse : Codable{
    let results:[Studentlocation]
}
struct Studentlocation : Codable{
    let createdAt:String?
    let firstName:String?
    let lastName:String?
    let latitude:Double?
    let longitude:Double?
    let mapString:String?
    let mediaURL:String?
    let objectId:String?
    let uniqueKey:String?
    let updatedAt:String?
    
}

struct PostResponse : Codable{
    let objectId:String?
    let createdAt:String?
}

struct PutResponse :Codable {
    let updatedAt:String?
}

class ParseClient{
    static func getMethodForStudentsLocation(completionHandlerForStudentsLocation: @escaping (_ studentsLocation:locationResponse?,_ errorCode:Int?)->Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String,_ errorCode:Int?) {
                print(error)
                completionHandlerForStudentsLocation(nil, errorCode)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                //network connection error
                sendError("There was an error with your request: \(error!)",nil)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! it is = \(String(describing: (response as! HTTPURLResponse).statusCode))",((response as? HTTPURLResponse)?.statusCode)!)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!",nil)
                return
            }
            
            do {
                let locations = try JSONDecoder().decode(locationResponse.self,from: data)
                print(locations.results[0])
                completionHandlerForStudentsLocation(locations,nil)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    
    
    static func getMethodForSingleStudentLocation(studentUniqueID:String, completionHandlerForSingleStudentLocation: @escaping (_ studentsLocation:locationResponse?,_ errorCode:Int?)->Void){
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        components.queryItems = [
            URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(studentUniqueID)\"}"),
        ]
        let url = components.url!
        print(url.absoluteString)
//        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=\(studentUniqueID)")!)
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String,_ errorCode:Int?) {
                print(error)
                completionHandlerForSingleStudentLocation(nil, errorCode)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                //network connection error
                sendError("There was an error with your request: \(error!)",nil)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! it is = \(String(describing: (response as! HTTPURLResponse).statusCode))",((response as? HTTPURLResponse)?.statusCode)!)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!",nil)
                return
            }
            do {
                let locations = try JSONDecoder().decode(locationResponse.self,from: data)
                print(locations.results.debugDescription)
                completionHandlerForSingleStudentLocation(locations,nil)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    static func postMethodForStudentLocation(uniqueId:String, firstName:String, lastName:String, mapString:String, mediaURL:String, latitdude:Double, longitude:Double, completionHandlerForSingleStudentLocation: @escaping (_ studentsLocation:PostResponse?,_ errorCode:Int?)->Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueId)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitdude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String,_ errorCode:Int?) {
                print(error)
                completionHandlerForSingleStudentLocation(nil, errorCode)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                //network connection error
                sendError("There was an error with your request: \(error!)",nil)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! it is = \(String(describing: (response as! HTTPURLResponse).statusCode))",((response as? HTTPURLResponse)?.statusCode)!)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!",nil)
                return
            }
            
            do {
                let locations = try JSONDecoder().decode(PostResponse.self,from: data)
                completionHandlerForSingleStudentLocation(locations,nil)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    
    
    static func putMethodForStudentLocation(objectId:String, uniqueId:String, firstName:String, lastName:String, mapString:String, mediaURL:String, latitdude:Double, longitude:Double, completionHandlerForUpdatingSingleStudentLocation: @escaping (_ studentsLocation:PutResponse?,_ errorCode:Int?)->Void){
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueId)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitdude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            
            func sendError(_ error: String,_ errorCode:Int?) {
                print(error)
                completionHandlerForUpdatingSingleStudentLocation(nil, errorCode)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                //network connection error
                sendError("There was an error with your request: \(error!)",nil)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! it is = \(String(describing: (response as! HTTPURLResponse).statusCode))",((response as? HTTPURLResponse)?.statusCode)!)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!",nil)
                return
            }
            
            do {
                let locations = try JSONDecoder().decode(PutResponse.self,from: data)
                completionHandlerForUpdatingSingleStudentLocation(locations,nil)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
}
