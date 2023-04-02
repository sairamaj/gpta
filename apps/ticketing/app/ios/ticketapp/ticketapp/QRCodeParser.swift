//
//  QRCodeParser.swift
//  QRCodeReader
//
//  Created by Dad on 4/1/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import Foundation

struct QRCodeParser {
    static func parse(val:String) throws -> TicketHolder {

        let arr = val.components(separatedBy: ",")
        // return QRCodeParser(name: arr[0], email: arr[1], id: arr[2], adults: Int(arr[3]), kids: Int(arr[4]))
        if arr.count < 5{
            throw QRCodeParseError.notAValidTicket
        }

        let name = arr[0]
        let email = arr[1]
        let id = arr[2]
        let adults = Int(arr[3]) ?? 0
        let kids = Int(arr[4]) ?? 0
        return TicketHolder(serialNumber: 1, name: name, confirmationNumber: id, adultCount: adults, kidCount: kids, member: 0, cost: 0)
    }
}
