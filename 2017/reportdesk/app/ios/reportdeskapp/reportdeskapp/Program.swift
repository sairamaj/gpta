//
//  Program.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/19/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

class Program{
    var Name: String!
    internal var ProgramTime:String!
    internal var Sequence:Int!
    internal var ReportTime:String!
    internal var GreenroomTime:String!
    internal var Duration:String!
    internal var Choreographer:String!
    internal var Participants:[Participant] = []
    
    init(name:String ){
        self.Name = name
 
    }
    
    func getParticipants()->[Participant]{
        return self.Participants
    }
    
    func addParticipant(participant: Participant) -> Void{
        self.Participants.append(participant)
    }
    
    func areAllParticipantsArrived()->Bool{
        for p in self.Participants{
            if(!p.arrived){
                return false
            }
        }
        
        return true
    }
    
    func getArrivedCount() -> Int{
        var count:Int = 0
        for p in self.Participants{
            if(p.arrived){
                count += 1
            }
        }
        return count
    }
    
    func getParticipantsCount() -> Int{
        return self.Participants.count
    }
}
