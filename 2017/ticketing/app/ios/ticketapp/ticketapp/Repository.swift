//
//  Repository.swift
//  ticketapp
//
//  Created by Sourabh Jamlapuram on 4/2/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

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
    
    var ticketHolders:[TicketHolder]! = []
    
    
    func getTicketHolders(callback : @escaping ( [TicketHolder]) -> Void){
        let apiPath: String = "/tickets/"
        get( url: URL(string: getApiUrl(resource: apiPath))!, callback: {
            (json) -> Void in
            
            var idCounter:Int = 1
            var ticketHolders = [TicketHolder]()
            for m in json{
                if let dictionary = m as? [String: Any] {
                    let name = dictionary["name"] as! String
                    let confirmationNumber = dictionary["id"] as! String
                    let adultCount = Int(dictionary["adults"] as! String)
                    let kidsCount = Int(dictionary["kids"] as! String)
                    let ticketHolder = TicketHolder(id:idCounter, name: name, confirmationNumber: confirmationNumber, adultCount: adultCount!, kidCount: kidsCount!)
                    ticketHolders.append(ticketHolder)
                    idCounter += 1
                }
                
            }
      
            // set ticket holders
            self.ticketHolders = ticketHolders        // side effect. todo: need to set this explict call.
            callback(ticketHolders)
            
        })
    }
    
    func updateTicketHolder( _ ticketHolder : TicketHolder){
        
    }

    
    /*http get utility function
     */
    func get(url:URL,callback : @escaping ([Any]) -> Void){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                // Slim.error(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        
                        callback(json)
                    }
                    
                } catch {
                    
                    //  Slim.trace("Repository.get error in JSONSerialization...")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    func getApiUrl(resource:String) ->String{
        return "https://parfmou7ta.execute-api.us-west-2.amazonaws.com/Prod" + resource
    }
}
