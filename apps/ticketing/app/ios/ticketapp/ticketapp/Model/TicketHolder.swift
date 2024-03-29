//
//  TicketHolder.swift
//  ticketapp
//
//  Created by Sourabh Jamlapuram on 4/2/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

class TicketHolder{
    
    var Name:String!
    var ConfirmationNumber:String!
    var AdultCount:Int
    var KidCount:Int
    var AdultsArrived:Int
    var KidsArrived:Int
    var SerialNumber:Int
    var isSynced:Int
    var Member:Int
    var Cost:Int
    
    init(serialNumber:Int,
         name:String ,
         confirmationNumber:String,
         adultCount:Int,
         kidCount:Int,
         member:Int,
         cost:Int){
        
        self.Name = name
        self.ConfirmationNumber = confirmationNumber
        self.AdultCount = adultCount
        self.KidCount = kidCount
        self.AdultsArrived = 0
        self.KidsArrived = 0
        self.SerialNumber = serialNumber
        self.isSynced = -1
        self.Member = member
        self.Cost = cost
    }
    
    
    func getArrivalStatus() -> TicketHolderArrivalStatus{
        let totalArrived = self.KidsArrived + self.AdultsArrived
        let totalCount = self.KidCount + self.AdultCount
        
        if( totalArrived == 0){
            return TicketHolderArrivalStatus.noneArrived
        }else if( totalArrived < totalCount){
            return TicketHolderArrivalStatus.partialArrived
        }
        
        return TicketHolderArrivalStatus.allArrived
    }
    
    func markAllArrived() -> Void{
        self.AdultsArrived = self.AdultCount
        self.KidsArrived = self.KidCount
    }
    
    func getTotalArrived() ->Int{
        return self.AdultsArrived + self.KidsArrived
    }
    
    func getTotalTickets() ->Int{
        return self.AdultCount + self.KidCount
    }
}
