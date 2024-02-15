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
    var searchDelay = 0.5 // Delay in seconds
    var model = PopupSearchViewModel() // Initialize your search view model
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .foregroundColor(.black)
                        .onChange(of: searchText) { oldState, newState in
                            model.cancellable?.cancel()
                            model.cancellable = Timer.publish(every: searchDelay, on: .main, in: .common)
                                .autoconnect()
                                .sink { _ in
                                    model.performSearch(with: searchText)
                                }
                        }
                    
                    // if my search function returns a list of string, how do i create one custom control for each string and populate a list here, with these controls ?
                    
                    if model.searchResults.isEmpty {
                        if model.searchResults == nil {
                            Text("Searching...").background(Color.background)
                        } else {
                            Text("No results found").background(Color.clear)
                        }
                    } else {
                        List(model.searchResults, id: \.self) { result in
                            Text(result)
                                .background(Color.clear)
                                .listRowBackground(Color.white)
                                .foregroundColor(.black)
                            // Customize this Text view as per your requirement for each string result
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
}



class PopupSearchViewModel: ObservableObject {
    @Published var searchResults: [String] = []
    var cancellable: AnyCancellable?

    func performSearch(with searchText: String) {
        print("Performing search with text: \(searchText)")
        // Implement your search logic here
        // For demonstration, let's say we're populating some sample data
        searchResults = ["Result 1", "Result 2", "Result 3"]
    }
}


#Preview {
    HomeView()
}
