//
//  PopupSearchView.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 10/02/2024.
//

import Foundation
import SwiftUI
import Combine

struct PopupSearchView: View {
    @Binding var isShowingPopup: Bool
    @State var searchText = ""
    @State private var isPreviewPlaying = false
    @StateObject var track : Track

    var searchDelay = 0.8 // Delay in seconds
    var model = PopupSearchViewModel() // Initialize your search view model
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    SearchBar(text: $searchText)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 12)
                        .onChange(of: searchText) { oldState, newState in
                            model.performSearch(with: searchText, debounceTime: searchDelay)
                                }
                    
                    if model.searchResults.isEmpty {
                        Text("No results found").offset(y:50)
                       
                    } else {
                        List(model.searchResults, id: \.videoTitle) { result in
                            HStack {
                                Button(action: {
                                    triggerDownload(for: result)
                                }) {
                                    Text(result.videoTitle)
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button(action: {
                                        //togglePreview(for: result)
                                }) {
                                    Image(systemName: result.isPlaying  ? "pause.circle.fill" : "play.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.white)
                        }.scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    Spacer()
                }
                
                .frame(height: 400)
                .background(Color.white).opacity(0.85)
                .cornerRadius(20)
                .padding(25)
                .offset(CGSize(width: 0.0, height: -190.0))
                .frame(height: 400)
            }
        }
    }
    
    func triggerDownload(for result: (videoTitle: String, videoId: String, isPlaying: Bool)) {
        Task {
            do {
                try await YoutubeHelper.downloadSong(with: result.videoId) { result in
                    switch result {
                        case .success(let filePath):
                            // File downloaded successfully, use the filePath
                            print("Song downloaded to: \(filePath)")
                            track.addSong(url: filePath, color: ColorUtil.getPaletteColor(2))
                            isShowingPopup.toggle()
                        case .failure(let error):
                            // Handle failure
                            print("Failed to download song: \(error)")
                    }
                }
            } catch {
                print("Failed to trigger download: \(error)")
                // Handle failure
            }
        }
    }

    
    func togglePreview(for result: (videoTitle: String, videoId: String, isPlaying:Bool)) {
        if self.isPreviewPlaying {
            self.isPreviewPlaying.toggle()
            YoutubeHelper.pausePreview()
        } else {
            self.isPreviewPlaying.toggle()
            Task {
                do {
                    try await YoutubeHelper.playPreview(with: result.videoId) // No calls to throwing functions occur within 'try' expression
                } catch { // 'catch' block is unreachable because no errors are thrown in 'do' block
                    print("Failed to play preview: \(error)")
                    self.isPreviewPlaying = false
                }
            }
        }
        
        model.searchResults = model.searchResults.map { item in
            if item.videoId == result.videoId {
                return (item.videoTitle, item.videoId, !item.isPlaying)
            } else {
                return item
            }
        }
    }
}



class PopupSearchViewModel: ObservableObject {
    @Published var searchResults: [(videoTitle: String, videoId: String, isPlaying: Bool)] = []

    var cancellable: AnyCancellable?

    func performSearch(with searchText: String) {
        
    
    }
    func performSearch(with searchText: String, debounceTime: TimeInterval) {
        cancellable?.cancel()
        cancellable = Future<Void, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + debounceTime) {
                promise(.success(()))
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { _ in
            print("Performing search with text: \(searchText)")
            
            YoutubeHelper.searchYouTubeVideos(searchString: searchText) { [weak self] (videoTitles, videoIds, error) in
                if let error = error {
                    print("Error performing search: \(error)")
                    return
                }
                
                // Update the searchResults array with the retrieved video titles and IDs
                DispatchQueue.main.async {
                    self?.searchResults = zip(videoTitles ?? [], videoIds ?? []).map { (title: $0, videoId: $1, isPlaying: false)  }
                }
            }
        }
    }
}

