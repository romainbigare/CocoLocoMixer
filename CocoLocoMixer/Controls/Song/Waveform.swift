//
//  Waveform.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 30/01/2024.
//
import Foundation
import SwiftUI

struct WaveformView: View {
    @StateObject var viewModel: SongViewModel
let fillColorHex: String
    let width = 400.0
    let height = 100.0

    var body: some View {
        let width = $viewModel.duration
        GeometryReader { geometry in
            Path { path in
                
                // Scale the waveform points to fit the width and height of the view
                let minValue = viewModel.waveformData.min() ?? 0.0
                let maxValue = viewModel.waveformData.max() ?? 1.0

                let scaledData = viewModel.waveformData.map {
                    100.0 * ($0 - minValue) / (maxValue - minValue)
                }

                let points: [CGPoint] = DoubleToPoints(values: scaledData)


                path = createPath(from: points, in: geometry, isClosed: true)
            }
            .fill(
                viewModel.isLoadingSong ?
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.8),
                            Color.gray.darker(by: 0).opacity(0.8)
                        ]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: fillColorHex).opacity(0.8),
                            Color(hex: fillColorHex).changeHue(by: 0).darker(by: 0).opacity(0.8)
                        ]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
            )
            .animation(viewModel.isLoadingSong ? Animation.easeInOut(duration: 2.0).repeatForever() : .default , value: UUID())
    
            
            .overlay(
                Path { path in
                    let minValue = viewModel.waveformData.min() ?? 0.0
                    let maxValue = viewModel.waveformData.max() ?? 1.0

                    let scaledData = viewModel.waveformData.map {
                        100.0 * ($0 - minValue) / (maxValue - minValue)
                    }

                    let points: [CGPoint] = DoubleToPoints(values: scaledData)

                    path = createPath(from: points, in: geometry, isClosed: false)
                }
                .stroke(
                    viewModel.isLoadingSong ?
                    Color.gray.darker(by:-30)
                    : Color(hex: fillColorHex).darker(by: -10), lineWidth: 3
                    
                )
            )
        }
        .onAppear {
            //viewModel.generateWaveformData()
        }
    }
    
    func DoubleToPoints(values:[Double]) -> [CGPoint]{
        
        let points :[CGPoint] =
        values.enumerated().map { index, value in
            CGPoint(x: CGFloat(index) / CGFloat(values.count - 1) * width, y: -value + height)
        }
        
        return points
    }
    
    
    func createPath(from points: [CGPoint], in geometry: GeometryProxy, isClosed : Bool) -> Path {
        let path = Path { path in
            
            // Move to the initial point
            path.move(to: CGPoint(x: 0, y: 0))
            
            // Apply the quadCurvedPath function to create the smooth curve
            let curvedPath = quadCurvedPath(with: points)
            
            path.addPath(Path(curvedPath.cgPath))
            
            
            // Connect the last point to the bottom-right corner
            if(isClosed){
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
            }
        }

        return path
    }
    
}





struct svp: PreviewProvider {
    static var previews: some View {
        VStack{
            //#d4afb9 // #d1cfe2 // #9cadce // #7ec4cf // #52b2cf
            SongView(mp3Song: "https://file-examples.com/storage/fed61549c865b2b5c9768b5/2017/11/file_example_MP3_5MG.mp3", fillColorHex: getPaletteColor(0))
            SongView(mp3Song: "your_song.mp3", fillColorHex: getPaletteColor(1))
            SongView(mp3Song: "your_song.mp3", fillColorHex: getPaletteColor(2))
            SongView(mp3Song: "your_song.mp3", fillColorHex: getPaletteColor(3))
            SongView(mp3Song: "your_song.mp3", fillColorHex: getPaletteColor(4))
        }
    }
}
