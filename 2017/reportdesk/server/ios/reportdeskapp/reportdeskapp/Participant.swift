//
//  Participant.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/21/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

class Participant{
    var id:String!
    var name: String!
    var arrived: Bool
    
    init(id:String, name:String){
        self.id = id
        self.name = name
        self.arrived = false
    }
    
    func setArrivalInfo(arrived:Bool) -> Void{
        self.arrived = arrived
    }
    
    func getId()->String{
        return self.id
    }
}
