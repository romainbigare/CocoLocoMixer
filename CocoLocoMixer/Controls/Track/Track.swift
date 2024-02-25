//
//  TrackViewModel.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 03/02/2024.
//

import Foundation
import SwiftUI


class Track: ObservableObject {
    @Published var songs: [Song] = []
    
    func addSong(url: String, color: String) {
        let newSong = Song(url: url, color: color)
        songs.append(newSong)
    }
    
    func PlayFrom(time:CGFloat){
        let currentTime = AppSettings.pixelsToTime(currentTime: time)
        
        // play from there
        
    }
    
    
}
