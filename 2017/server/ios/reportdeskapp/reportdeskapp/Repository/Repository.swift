//
//  Repository.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/19/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation


/*
 Tried aws SDK to communicate to API gateway, but at this time there were some problems with swift 3.0 version (currently they support only 2.0). Once it is available we will integrate aws-sdk
 */
class Repository{
    
    /*
     class communicates to aws REST api for mom restaurant items
     */
    public static let shared:Repository = {
        return Repository()
    }()
    
    /*
     Cannot create instance. (singleton pattern)
     */
    private init(){
        
    }
    
    func getPrograms(callback : @escaping ( [Program]) -> Void){
        get( url: URL(string: getApiUrl(resource: "/events/54e0016a-fda3-4e35-86e1-5e17022627d4/programs"))!, callback: {
            (json) -> Void in
            
            var programs = [Program]()
            print(json)
            for m in json{
                if let dictionary = m as? [String: Any] {
                                        let name = dictionary["name"] as! String
                    
                    let program = Program(name: name)
                    programs.append(program )
                    
                }
            }
            
            callback(programs)
            
            
        })
    }
    
    /*
     http get utility function
     */
    func get(url:URL,callback : @escaping ([Any]) -> Void){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        
                        callback(json)
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    func getApiUrl(resource:String) ->String{
        return "https://rzkowjvkb0.execute-api.us-west-2.amazonaws.com/Prod" + resource
    }
}
