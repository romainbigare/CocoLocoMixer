//
//  Greetings.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 04/02/2024.
//

import Foundation
import SwiftUI

struct GreetingView: View {
    @Binding var isTitleVisible: Bool
    @Binding var hasGreetedUser: Bool

    var body: some View {
        VStack {
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
                                self.hasGreetedUser.toggle()
                            }
                        }
                    }
                }
        }
    }
}

