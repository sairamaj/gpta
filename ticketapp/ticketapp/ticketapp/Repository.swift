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
        
        let ticketHolders = loadTicketHolders()
        callback(ticketHolders)

    }
    
    func updateTicketHolder( _ ticketHolder : TicketHolder){
        
    }
    
    func loadTicketHolders() ->[TicketHolder]{
        
        var ticketHolders:[TicketHolder] = []
        var idCounter:Int = 1

        
        if let filepath = Bundle.main.path(forResource: "TicketHolderData", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                let array = contents.components(separatedBy: "\n")
                
                for (_,element) in array.enumerated(){
                    if( element.trim().length > 0 ){
                        var parts = element.components(separatedBy : "|")
                        //var ticketHolder = TicketHolder(name: parts[0], confirmationNumber: parts[1], adultCount: parts[2].toInt()!, kidCount: parts[3].toInt()!)
                        print("element: \(element) \n")
                        let ticketHolder = TicketHolder(id:idCounter, name: parts[0], confirmationNumber: parts[1], adultCount: Int(parts[2])!, kidCount: Int(parts[3])!)
                        ticketHolders.append(ticketHolder)
                        idCounter += 1
                    }
                }

            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
        return ticketHolders
    }
}
