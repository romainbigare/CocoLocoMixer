//
//  TrackView.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 03/02/2024.
//

import Foundation
import SwiftUI

struct TrackView: View {
    @StateObject var model: Track
    @State private var previewTickPosition: CGFloat = AppSettings.timeMargins
    @State private var tickPosition: CGFloat = AppSettings.timeMargins
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false

    var body: some View {
            ScrollView(.horizontal, showsIndicators: false){
                ZStack(alignment: .leading){
                    
                    
                    HStack(spacing: 0){
                        Spacer(minLength:AppSettings.timeMargins+10)
                        
                        if model.songs.isEmpty {
                            Text("Add songs").offset(y:50)
                           
                        } else {
                            ForEach(model.songs, id: \.id) { song in
                                SongView(song: song)
                            }
                        }
                        
                        Spacer(minLength:AppSettings.timeMargins)

                    }
                    
                    PlayerTick(currentTime:$previewTickPosition)
                        .offset(CGSize(width: previewTickPosition, height: isDragging ? (40 * AppSettings.globalZoomLevel ): (80 * AppSettings.globalZoomLevel )))
                        .highPriorityGesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onChanged() { value in
                                    previewTickPosition = tickPosition + value.translation.width
                                    if(previewTickPosition<AppSettings.timeMargins) {previewTickPosition = AppSettings.timeMargins}
                                    isDragging = true
                                }
                                .onEnded() { value in
                                    tickPosition += (value.translation.width)
                                    if(tickPosition<AppSettings.timeMargins) {tickPosition = AppSettings.timeMargins}
                                    isDragging = false
                                    self.model.PlayFrom(time:tickPosition)
                                }
                        )
                        .frame(height:180 * AppSettings.globalZoomLevel + 10)
                    
                    Spacer(minLength: 50)
                }
            }
    }
}


/*
   
            let link1 = "https://www.dropbox.com/s/dl/620qqip91g6td9t/Double%20Violin%20Concerto%201st%20Movement%20-%20J.S.%20Bach.mp3"
            let link2 = "https://www.dropbox.com/s/dl/z2y19b73lowzwzn/TAMMY%20-%20Stan%20Devereaux.mp3"
            let link3 = "https://www.dropbox.com/s/dl/rj2bg5i2jzd66yu/03%20Tammy.mp3"
            let link4 = "https://www.dropbox.com/s/dl/rx5vor1omr3lots/good_old_whats_her_name.mp3"
            let link5 = "https://www.dropbox.com/s/dl/3c1s371iobkc5ny/01%20Brand%20New%20Girlfriend.mp3"
            
            let links = [link1, link2, link3, link4, link5]
            
            
            ForEach(0..<5) { index in
                SongView(mp3Song: links[index], fillColorHex: ColorUtil.getPaletteColor(index), testing:self.testing)
     
    }*/
