//
//  ArrayExtension.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/21/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

extension Array{

    func any(fn: (Element) -> Bool) -> Bool {
        return self.find(fn: fn).count > 0
    }
    
    
    func find(fn: (Element) -> Bool) -> [Element] {
        var to = [Element]()
        for x in self {
            let t = x as Element
            if fn(t) {
                to.append(t)
            }
        }
        return to
    }
    

    
    func forEach(doThis: (_ element: Element) -> Void) {
        for e in self {
            doThis(e)
        }
    }
    
}
