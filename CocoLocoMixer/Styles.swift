//
//  Styles.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 28/01/2024.
//

import Foundation
import SwiftUI


struct RoundedButton: View {
    var action: () -> Void
    var label: String
    var systemImage: String
    
    var body: some View {
        Button(action: action) {
            HStack (alignment: .center) {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                
                Text(label)
                    .foregroundColor(.white)
                    .font(.caption)
                    .frame(width: 70, alignment: Alignment.leading)
                    .padding(.horizontal, 10)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue))
            .frame(width: 400, height: 30)
        }
    }
}


#Preview {
    VStack(spacing: 30) {
        RoundedButton(action: {
            // Action for Download button
        }, label: "Download", systemImage: "arrow.down.circle")
        
        RoundedButton(action: {
            // Action for Open button
        }, label: "Open", systemImage: "folder")
        
        RoundedButton(action: {
            // Action for Mix button
        }, label: "Mix", systemImage: "slider.horizontal.3")
    }
}
