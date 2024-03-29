//
//  Settings.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 4/7/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import Foundation

class Settings{
    
    
    public static let shared:Settings = {
        return Settings()
    }()
    
    private init(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        
    }
    
    public func IsAutoRefreshEnabled() -> Bool{
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "auto_refresh")
    }
    
    public func getAutoRefreshIntervalInMinutes() -> Int{
        let defaults = UserDefaults.standard
        var val = defaults.integer(forKey: "auto_refresh_interval")
        if val < 2 {
            val = 2
        }
        
        return val * 60 // make it in minutes.
        
    }
}
