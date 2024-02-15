//
//  wf.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 04/02/2024.
//

import Foundation
import SwiftUI

#Preview {
    WaveformView(data: nil, width: 300, color: ColorUtil.getPaletteColor(6))
}

struct WaveformView: View {
    @State var gradientOpacity: Double = 0.8
    let data: [Double]?
    let width: Double
    let color: String

    var body: some View {
        if let unwrappedData = data {
            WaveformShape(data: unwrappedData, width: width)
                .fill(ColorUtil.getLinearGradient(color:color))
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                .frame(width:width, height:AppSettings.waveformHeight)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .padding(0)

        }
        else{
            WaveformShape(data: [0.1, 0.4, 0.3, 0.1, 0.5, 0.4, 0.2, 0.1, 0.3, 0.1], width: width)
                .fill(ColorUtil.getLinearGradient(color:color))
                .opacity(gradientOpacity)
                .onAppear {
                   withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {gradientOpacity = 0.8}
                }
                .frame(width:width, height:AppSettings.waveformHeight)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .padding(0)
        }
    }
}

struct WaveformShape: Shape {
    let data: [Double]
    let width: Double

    func path(in rect: CGRect) -> Path {
        let scaledData: [Double] = ScaleData(for: data)
        let points: [CGPoint] = DoubleToPoints(values: scaledData, width: width)
        return createPath(from: points, isClosed: true, width: width)
    }
    
    func ScaleData(for waves:[Double]) -> [Double]{
        let maxValue = waves.max() ?? 1.0
        let mult = AppSettings.waveformHeight / maxValue
        return waves.map {$0 * mult}
    }
    
    func DoubleToPoints(values:[Double], width:Double) -> [CGPoint]{
        let points :[CGPoint] =
        values.enumerated().map { index, value in
            CGPoint(x: CGFloat(index) / CGFloat(values.count - 1) * width, y: value)
        }
        
        return points
    }
    
    func createPath(from points: [CGPoint], isClosed : Bool, width : Double) -> Path {
        let path = Path { path in
            
            // Move to the initial point
            path.move(to: CGPoint(x: 0, y: 0))
            
            // Apply the quadCurvedPath function to create the smooth curve
            let curvedPath = quadCurvedPath(with: points)
            
            path.addPath(Path(curvedPath.cgPath))
            // Connect the last point to the bottom-right corner
            if(isClosed){
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.closeSubpath()
            }
        }

        return path
    }
}
