//
//  LoadingView.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 28/01/2024.
//

import SwiftUI
import Foundation
import Lottie


struct LottieView: UIViewRepresentable {
    let lottieFile: String
 
    let animationView = LottieAnimationView()
 
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
 
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
 
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        return view
    }
 
    func updateUIView(_ uiView: UIViewType, context: Context) {
 
    }
}


struct LoadingView: View {
    var progress: Double
    
    var body: some View {
        VStack {
            LottieView(lottieFile: "loading1")
                .frame(width: 200, height: 200)
                .padding()
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(0.6)
                .padding()
            
            Text("Loading")
                .padding()
        }
    }
}


#Preview {
    LoadingView(progress:0.3)
}
