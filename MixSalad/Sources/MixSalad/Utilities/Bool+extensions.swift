//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 24/01/21.
//

import Foundation
public extension Bool {
        
    init?(bit: Int) {
        switch bit {
        case 0:
            self = false
        case 1:
            self = true
        default:
            return nil
        }
    }
}
