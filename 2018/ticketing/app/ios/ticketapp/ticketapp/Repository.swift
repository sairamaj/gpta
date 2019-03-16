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
        // let apiUrl = URL(string: getApiUrl(resource: apiPath))!

        get( url: URL(string: getApiUrl(resource: apiPath))!, callback: {
            (json) -> Void in
            
            var serialNumber:Int = 1
            var ticketHolders = [TicketHolder]()
            for m in json{
                if let dictionary = m as? [String: Any] {
                    let name = dictionary["name"] as! String
                    let confirmationNumber = dictionary["id"] as! String

                    var adultCount =  0
                    if let val = dictionary["adults"] {
                        adultCount = Int(val as! String)!
                    }
                    
                    var kidsCount =  0
                    if let val = dictionary["kids"] {
                        kidsCount = Int(val as! String)!
                    }

                    let ticketHolder = TicketHolder(serialNumber:serialNumber, name: name, confirmationNumber: confirmationNumber, adultCount: adultCount, kidCount: kidsCount)
                    ticketHolders.append(ticketHolder)
                    serialNumber += 1
                }
                
            }
            
            // set ticket holders
            self.ticketHolders = ticketHolders        // side effect. todo: need to set this explict call.
            callback(ticketHolders)
            
        })
    }
    
    func updateTicketHolder( _ ticketHolder : TicketHolder){
        
        let date = NSDate();
        // "Apr 1, 2015, 8:53 AM" <-- local without seconds
        
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!;
        let utcTimeZoneStr = formatter.string(from: date as Date);
        
        let checkInfo = String(format:"{" +
            "\"id\": \"\(ticketHolder.ConfirmationNumber!)\" , " +
            "\"adults\": \"\(ticketHolder.AdultsArrived)\" ," +
            "\"kids\": \"\(ticketHolder.KidsArrived)\" ," +
            "\"updatedAt\": \"\(utcTimeZoneStr)\" " +
            "}")
        
        
        Slim.trace(checkInfo)
        
        
        post( url: URL(string: getApiUrl(resource: "/tickets/checkins"))!, input:checkInfo, callback: {
            (json) -> Void in
            
            Slim.info("checkin was saved successfully")
        })
    }
    
    func refreshTicketHolderInfo(ticketHolders:[TicketHolder], callback : @escaping ( [TicketHolder]) -> Void){
        get( url: URL(string: getApiUrl(resource: "/tickets/checkins"))!, callback: {
            (json) -> Void in
            
            Slim.trace(json)
            for m in json{
                if let dictionary = m as? [String: Any] {
                    let id = dictionary["id"] as! String
                    let adultsArrived = (Int)(dictionary["adults"] as! String)
                    let kidsArrived = (Int)(dictionary["kids"] as! String)
                    
                    
                    for ticketHolder in ticketHolders{
                        if ticketHolder.ConfirmationNumber == id{
                            ticketHolder.AdultsArrived = adultsArrived!
                            ticketHolder.KidsArrived = kidsArrived!
                            
                        }
                    }
                }
                
            }
            
            callback(ticketHolders)
            
        })
    }
    
    /*http get utility function
     */
    func get(url:URL,callback : @escaping ([Any]) -> Void){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                Slim.error(error!.localizedDescription)
                
            } else {
                
                do {
                    Slim.info("Repository.get got response...")
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        Slim.info("Parsed tickets response.")
                        callback(json)
                    }else{
                        Slim.error("Unable to parse the response.")
                    }
                    
                } catch {
                    
                    Slim.error("Repository.get error in JSONSerialization...")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    
    /*
     http post utility function.
     */
    func post(url:URL, input:String, callback : @escaping ([Any]) -> Void){
        
        //var input:String = ""
        // Slim.trace(input)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = input.data(using: .utf8)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                Slim.error(error!.localizedDescription)
                
            } else {
                
                do {
                    Slim.trace(data as Any)
                    if let httpResponse = response as? HTTPURLResponse{
                        if httpResponse.statusCode == 200{
                            Slim.info("post returned 200(ok)")
                        }else{
                            Slim.error("post returned \(httpResponse.statusCode)")
                        }
                    }
                }
            }
            
        })
        task.resume()
        
    }
    
    func getApiUrl(resource:String) ->String{
       // return "https://parfmou7ta.execute-api.us-west-2.amazonaws.com/Prod" + resource
        return "http://127.0.0.1:4000" + resource
    }
}
