//
//  MessageCollectorLogDestination.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 4/7/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation
import UIKit

class MessageCollectorLogDestination : LogDestination{
    
    let MAXMESSAGECOUNT:Int = 100
    let REDUCEMESSAGEBYAFTERLIMIT:Int = 20
    var messageCountId:Int = 0
    var messages : Array<LogMessage> = Array()
    var tableViewTobeRefreshed : UITableView!
    
    public static let shared:MessageCollectorLogDestination = {
        return MessageCollectorLogDestination()
    }()
    
    private init(){
        
    }
    
    public func setup() -> Void{
        Slim.addLogDestination(self as LogDestination)
    }
    
    /*
     Temporary solution: ideal will be to use observer pattern.
     */
    public func addTableViewForRefresh(tableView: UITableView){
        tableViewTobeRefreshed = tableView
    }
    
    let dateFormatter = DateFormatter()
    let serialLogQueue: DispatchQueue = DispatchQueue(label: "ConsoleDestinationQueue")
    
    func log<T>( _ message: @autoclosure () -> T, level:LogLevel,
             filename: String, line: Int) {
        if level.rawValue >= SlimConfig.consoleLogLevel.rawValue {
            let msg = message()
            self.serialLogQueue.async {
                //  self.messages.append(String(format:"\(self.dateFormatter.string(from: Date() as Date)):\(level.string):\(filename):\(line) - \(msg)"))
                self.messageCountId += 1
                let logMessage = LogMessage( id: self.messageCountId, dateTime: Date() , fileName: filename, line: line,  logType: level.string, message: msg as! String)
                self.messages.insert(logMessage, at: 0)
                if self.messages.count > self.MAXMESSAGECOUNT{
                    let range = self.messages.endIndex.advanced(by: -self.REDUCEMESSAGEBYAFTERLIMIT)..<self.messages.endIndex
                    self.messages.removeSubrange(range)
                }
                
                if self.tableViewTobeRefreshed != nil{
                    DispatchQueue.main.async {
                        self.tableViewTobeRefreshed.reloadData()    // reload in UI thread.
                    }
                }
                
            }
        }
    }
}
