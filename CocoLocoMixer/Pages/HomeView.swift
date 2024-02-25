//
//  ContentView.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 28/01/2024.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    @StateObject var track = Track()
    
    @State private var hasGreetedUser = true
    @State private var isTitleVisible = false
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var isShowingPopupAdd = false
    @State private var isShowingPopupSearch:Bool = false // State variable for the search popup
    @State private var isPlaying = false
    @State private var downloadedFile: URL? // Store the downloaded file

    
    var arePopupsOpen: Bool {
        return isShowingPopupAdd || isShowingPopupSearch
    }


    var body: some View {
        if !hasGreetedUser
        {
            GreetingView(isTitleVisible: $isTitleVisible, hasGreetedUser:$hasGreetedUser)
        }

        else{
            ZStack {
                ZStack{
                    TrackView(model: track)
                        .blur(radius: arePopupsOpen ? 25 : 0)
                        .onTapGesture {
                            // Close all popups when tapping outside
                            isShowingPopupAdd = false
                            isShowingPopupSearch = false
                        }
                    VStack{
                        Spacer()
                        BottomBar(
                            isShowingPopupAdd: $isShowingPopupAdd,
                            isPlaying: $isPlaying
                        )
                    }
                }
                // Popup
                if isShowingPopupAdd {
                    PopupAddView(
                        isShowingPopup: $isShowingPopupAdd,
                        isShowingPopupSearch: $isShowingPopupSearch,
                        track : track
                    )
                }
                
                if isShowingPopupSearch{
                    PopupSearchView(
                        isShowingPopup: $isShowingPopupSearch,
                        track : track
                    )
                }
            }
            .background(Color.black)

        }

    }
}

#Preview {
    HomeView()
} 
