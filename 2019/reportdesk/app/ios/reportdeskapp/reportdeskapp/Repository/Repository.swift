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
     class communicates to aws REST api for report desk
     */
    public static let shared:Repository = {
        return Repository()
    }()
    
    /*
     Cannot create instance. (singleton pattern)
     */
    private init(){
        
    }
    
    var programs:[Program] = []
    
    func getAllParticipants() -> [Participant]{
        var allParticipants = [Participant]()
        for p in programs{
            for pp in p.Participants{
                allParticipants.append(pp)
            }
        }
        
        return allParticipants
    }
    
    func getPrograms(callback : @escaping ( [Program]) -> Void){
        
        getEventId(callback:
            { (id) -> Void  in
                print(id)
                
                let apiPath: String = "/events/" + id + "/programs"
                self.get( url: URL(string: self.getApiUrl(resource: apiPath))!, callback: {
                    (json) -> Void in
                    
                    var programs = [Program]()
                    Slim.trace(json)
                    for m in json{
                        if let dictionary = m as? [String: Any] {
                            let name = dictionary["name"] as! String
                            
                            
                            let program = Program(name: name)
                            program.Choreographer = dictionary["choreographer"] as! String
                            program.ProgramTime = dictionary["programtime"] as! String
                            program.ReportTime = dictionary["reporttime"] as! String
                            program.GreenroomTime = dictionary["greenroomtime"] as! String
                            program.Duration = dictionary["duration"] as! String
                            program.Sequence = Int(dictionary["sequence"] as! String)
                            programs.append(program )
                            
                            if let participants = dictionary["participants"] as? [Any] {
                                for participant in participants{
                                    if let participantsInfo = participant as? [String:Any]{
                                        Slim.trace(participantsInfo["name"] as! String)
                                        program.addParticipant(participant: Participant(id: participantsInfo["id"] as! String, name: participantsInfo["name"] as! String) )
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    callback(programs)
                    
                    Repository.shared.refreshParticipantArrivalInfo(programs: programs, callback:    {
                        (objects) -> Void in
                    })
                    // set programs
                    self.programs = programs        // side effect. todo: need to set this explict call.
                })
                
        })
    }
    
    
    func getEventId(callback : @escaping (String) -> Void){
        
        let apiPath: String = "/events/"
        get( url: URL(string: getApiUrl(resource: apiPath))!, callback: {
            (json) -> Void in
            for m in json{
                if let dictionary = m as? [String: Any] {
                    let firstEventId = dictionary["id"] as! String
                    callback(firstEventId)
                }
            }
        })
    }
    
    
    func refreshParticipantArrivalInfo(programs:[Program], callback : @escaping ( [Program]) -> Void){
        get( url: URL(string: getApiUrl(resource: "/participants/arrivalinfo"))!, callback: {
            (json) -> Void in
            
            Slim.trace(json)
            for m in json{
                if let dictionary = m as? [String: Any] {
                    let id = dictionary["id"] as! String
                    let arrived = (Int)(dictionary["arrived"] as! String)
                    /*var arrived = 0
                    if let val = dictionary["arrived"] as! String{
                        arrived = Int(val)
                    }*/
                    
                    
                    for program in programs{
                        for participant in program.getParticipants(){
                            if( participant.getId() == id){
                                if( !participant.arrived ){ // update only if not arrived in local ( local arrived is up to date. todo: need to add time stamp so that we can take the latest.
                                    participant.setArrivalInfo(arrived: arrived==1 ? true: false)
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
            callback(programs)
            
        })
    }
    
    func updateParticipantArrivalInf(id:String, isArrived:Bool){
        
        let arrived = isArrived ? 1: 0
        let participantArrivalInfo = String(format:"{\"id\": \"\(id)\" , \"arrived\": \"\(arrived)\"}")
        Slim.trace(participantArrivalInfo)
        
        post( url: URL(string: getApiUrl(resource: "/participants/arrivalinfo"))!, input:participantArrivalInfo, callback: {
            (json) -> Void in
            
            Slim.info("participant was saved successfully")
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
                
                Slim.error(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        
                        callback(json)
                    }
                    
                } catch {
                    
                    Slim.trace("Repository.get error in JSONSerialization...")
                    
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
        Slim.trace(input)
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
        return "https://doqa6ru4vh.execute-api.us-west-2.amazonaws.com/Prod" + resource
    }
}
