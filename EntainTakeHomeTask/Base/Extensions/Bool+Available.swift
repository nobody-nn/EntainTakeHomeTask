//
//  Bool+Available.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/31.
//

import Foundation

extension Bool {
     static var aboveIOS16: Bool {
         guard #available(iOS 16, *) else {
             // It's below iOS 16 so return false.
             return false
         }
         // It's above iOS 16 so return true.
         return true
     }
    
    static var aboveIOS17: Bool {
        guard #available(iOS 17, *) else {
            // It's below iOS 17 so return false.
            return false
        }
        // It's above iOS 17 so return true.
        return true
    }
 }
