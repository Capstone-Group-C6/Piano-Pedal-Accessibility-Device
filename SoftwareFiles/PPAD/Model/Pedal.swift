//
//  Pedal.swift
//  PPAD
//
//  Created by Mr.Jos on 12/1/23.
//

import Foundation

struct Pedal {
    var inverse: Bool
    var angle: Double
    var type: Int
    var hold: Bool
    var state: Bool //Is on or not
    
    var holdOn = false
    var resetHold = false
    
    var isAbove: Bool = false
    
    // Add threshold detection method
    mutating func isAboveThreshold(highValue: Double, lowValue: Double) -> Bool {
        if state == true {
            let currentValue = inverse ? (highValue < lowValue) : (highValue > lowValue)
            
            // When hold functionality is enabled
            if hold {
                if !holdOn && currentValue {
                    isAbove = true
                    holdOn = true // First time crossing the threshold
                } else if holdOn && !currentValue {
                    resetHold = true // Reset hold when it goes below the threshold
                } else if resetHold && currentValue {
                    isAbove = !isAbove // Toggle isAbove when crossing the threshold again
                    resetHold = false // Reset the resetHold flag
                }
            } else {
                // Default behavior without hold functionality
                isAbove = currentValue
            }
            
            return isAbove
        } else {
            return false
        }
    }
}
