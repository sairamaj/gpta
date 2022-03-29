//
//  LogMessage.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 4/1/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

class LogMessage{
    var Id:Int
    var DateTime: Date
    var FileName:String
    var Line:Int
    var Message:String
    var LogType:String

    
    init( id:Int, dateTime:Date, fileName: String, line:Int, logType:String, message:String){
        self.Id = id
        self.DateTime = dateTime
        self.FileName = fileName
        self.Line = line
        self.LogType = logType
        self.Message = message
    }
}
