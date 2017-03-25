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
        let apiPath: String = "/events/" + getEventId() + "/programs"
        get( url: URL(string: getApiUrl(resource: apiPath))!, callback: {
            (json) -> Void in
            
            var programs = [Program]()
            print(json)
            for m in json{
                if let dictionary = m as? [String: Any] {
                                        let name = dictionary["name"] as! String
                    
                    let program = Program(name: name)
                    programs.append(program )
                    
                    if let participants = dictionary["participants"] as? [Any] {
                        for participant in participants{
                            if let participantsInfo = participant as? [String:Any]{
                                print(participantsInfo["name"] as! String)
                                program.addParticipant(participant: Participant(id: participantsInfo["id"] as! String, name: participantsInfo["name"] as! String) )
                            }
                        }

                        
                    }
         
                }
                
            }
            
            callback(programs)
            Repository.shared.getParticipantArrivalInfo(programs: programs)
        })
    }
    
    func getEventId() -> String{
        return "1d01a2de-d0d0-4829-bb0b-5d4b09a70e15"
        
    }
    
    func getParticipantArrivalInfo(programs:[Program]){
        get( url: URL(string: getApiUrl(resource: "/participants/arrivalinfo"))!, callback: {
            (json) -> Void in
            
            print(json)
            for m in json{
                if let dictionary = m as? [String: Any] {
                    let id = dictionary["id"] as! String
                    let arrived = (Int)(dictionary["arrived"] as! String)

                    print("id:" + id)
                                    
                    for program in programs{
                        for participant in program.getParticipants(){
                            if( participant.getId() == id){
                                participant.setArrivalInfo(arrived: arrived==1 ? true: false)
                            }
                        }
                    }
                    
                }
                
            }
            
            //callback(programs)
        })

    }
    
    func updateParticipantArrivalInf(id:String, isArrived:Bool){
        
        let arrived = isArrived ? 1: 0
        let participantArrivalInfo = String(format:"{\"id\": \"\(id)\" , \"arrived\": \"\(arrived)\"}")
        print(participantArrivalInfo)
        
        post( url: URL(string: getApiUrl(resource: "/participants/arrivalinfo"))!, input:participantArrivalInfo, callback: {
            (json) -> Void in
            
            print("menuitem was saved successfully")
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
    
    /*
     http post utility function.
     */
    func post(url:URL, input:String, callback : @escaping ([Any]) -> Void){
        
        //var input:String = ""
        print(input)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = input.data(using: .utf8)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    print(data as Any)
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        print(json)
                        callback(json)
                        
                    }else{
                        print("unable to deserialize.")
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
