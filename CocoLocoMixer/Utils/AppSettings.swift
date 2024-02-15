//
//  Settings.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 02/02/2024.
//

import Foundation
import SwiftUI

struct AppSettings {
    static var segmentSizeInSeconds : Double = 5.0
    static var waveformHeight : Double = 100.0 * globalZoomLevel
    static var secondsToPixelsMultiplier: Double = 1.7 * globalZoomLevel
    static var timeMargins : CGFloat = 75.0
    static var globalZoomLevel : Double = 1.0
    
    // one second is one pixel * waveformWidthMultiplier
    // Add other settings as needed
    
    static func SecondsToScreen(for second:Double?, fallback : Double = 0) -> Double{
        
        return Double(second ?? fallback) * secondsToPixelsMultiplier
    }
    
    static func SecondsToScreen(for second:Double?) -> Double?{
        
        if let s = second{
            return s * secondsToPixelsMultiplier
        }
        
        return nil
    }
    
    static func pixelsToTime(currentTime:CGFloat) -> String{
        let totalSeconds = (currentTime - timeMargins) / AppSettings.secondsToPixelsMultiplier
        let minutes = Int(floor(totalSeconds / 60))
        let seconds = Int(totalSeconds) % 60
        let ss = String(seconds).count < 2 ? "0"+String(seconds) : String(seconds)
        let ms = String(minutes).count < 2 ? "0"+String(minutes) : String(minutes)
        
        return String("\(ms):\(ss)")
    }
}

#Preview {
    HomeView()
}
