//
//  Program.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/19/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

class Program{
    var name: String!
    internal var Participants:[Participant] = []
    
    init(name:String ){
        self.name = name
 
    }
    
    func getParticipants()->[Participant]{
        return self.Participants
    }
    
    func addParticipant(participant: Participant) -> Void{
        self.Participants.append(participant)
    }
}
