//
//  ContentView.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 28/01/2024.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var hasGreetedUser = true
    @State private var isTitleVisible = false
    @State private var isRealContentVisible = true
    
    var body: some View {
        VStack {
            if !hasGreetedUser
            {
                Image(systemName: "music.note.house.fill")
                    .imageScale(.large)
                    .foregroundStyle(.primary)
                    .offset(y: isTitleVisible ? 0 : -350)
                    .opacity(isTitleVisible ? 1 : 0)
                    .scaleEffect(isTitleVisible ? 1 : 0.8)
                    .padding()
                
                Text("Hello, Romain!")
                    .offset(x: isTitleVisible ? 0 : -350)
                    .opacity(isTitleVisible ? 1 : 0)
                    .scaleEffect(isTitleVisible ? 1 : 0.8)
                    .onAppear {
                        withAnimation {
                            self.isTitleVisible.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                self.isTitleVisible.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    self.isRealContentVisible.toggle()
                                    self.hasGreetedUser
                                        .toggle()
                                    
                                }
                            }
                        }
                    }
            }
            
            
            if isRealContentVisible {
                // Your real content goes here
                VStack(spacing: 30) {
                    RoundedButton(action: {
                        viewModel.downloadAction()
                    }, label: "Download", systemImage: "arrow.down.circle")
                    
                    RoundedButton(action: {
                        viewModel.playAction()
                    }, label: "Play", systemImage: "play")
                    
                    RoundedButton(action: {
                        viewModel.pauseAction()
                    }, label: "Pause", systemImage: "pause")
                }
                
                VStack{
                    //#d4afb9 // #d1cfe2 // #9cadce // #7ec4cf // #52b2cf
                    
                    SongView(mp3Song: "https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_2MB_MP3.mp3", fillColorHex: getPaletteColor(0))
                    SongView(mp3Song: "https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_5MB_MP3.mp3", fillColorHex: getPaletteColor(2))
                }
            }
        }
        .padding()
    }
}


#Preview {
    HomeView()
} 
