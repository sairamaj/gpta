//
//  Extensions.swift
//  PopUpWindowExample
//
//  Created by John Codeos on 1/18/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.magenta
        }
        
        var rgb: UInt64 = 0
        Scanner.init(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
}

enum QRCodeParseError: Error {
    // Not a valid ticket
    case notAValidTicket
    
    // Throw in all other cases
    case unexpected(code: Int)
}

enum QRScanUpdateStatus {
    case unknown
    case success
    case ticketNotFound
    case alreadyArrived
}

extension QRCodeParseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAValidTicket:
            return "The provided password is not valid."
        case .unexpected(_):
            return "An unexpected error occurred while parsing QR code."
        }
    }
}

