//
//  Styles.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 06/02/2024.
//

import Foundation
import SwiftUI

struct StyleButtonGradient: ButtonStyle {
    
    var color1: String = ColorUtil.getPaletteColor(3)
    var color2: String = ColorUtil.getPaletteColor(4)
    
    init(colorIndex1: Int = 3, colorIndex2: Int = 4) {
        if(colorIndex1 > 0){
            self.color1 = ColorUtil.getPaletteColor(colorIndex1)
        }
        
        if(colorIndex2 > 0){
            self.color2 = ColorUtil.getPaletteColor(colorIndex2)
        }
        else{
            self.color2 = ColorUtil.getPaletteColor(colorIndex1+1)

        }
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex:self.color1), Color(hex:self.color2)]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(150.0)
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 150.0)
                    .stroke(Color.white, lineWidth: 1.0) // Adjust the lineWidth as needed
                    .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
            )
    }
}

