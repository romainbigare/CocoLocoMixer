//
//  PlayerTick.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 05/02/2024.
//

import Foundation
import SwiftUI

struct PlayerTick: View {
    @Binding var currentTime : CGFloat
    
    var formattedTime: String {
        return AppSettings.pixelsToTime(currentTime:currentTime)
    }
    
    var body: some View {
        Rectangle()
            .frame(width: 5, height: 120) // Adjust the size as needed
            .foregroundColor(Color.white.opacity(0.4))
            .cornerRadius(3)
            .shadow(color: .pink, radius: 4, x: 0, y: 0) // Adjust the shadow parameters
            .padding(6) // Adjust the values as needed
            .background(Color.white.opacity(0))
            
        Text(formattedTime) // Display currentTime as an integer
            .foregroundColor(.white)
            .font(.caption)
            .offset(CGSize(width: 20, height: 0))
    }
}
