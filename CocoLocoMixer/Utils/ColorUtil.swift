//
//  ColorUtil.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 30/01/2024.
//

import SwiftUI
import Foundation

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    func darker(by percentage: Double = 20.0) -> Color {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            let factor = 1.0 - (percentage / 100.0)

            return Color(
                red: max(red * CGFloat(factor), 0),
                green: max(green * CGFloat(factor), 0),
                blue: max(blue * CGFloat(factor), 0),
                opacity: alpha
            )
        }
    
    func changeHue(by percentage: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newHue = hue + CGFloat(percentage / 100.0)

        return Color(hue: min(max(newHue, 0.0), 1.0), saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    static let background = Color.white // Default background color for light mode
    
}

struct ColorUtil{
    
    static let paletteVintage = ["#ccd5ae", "#e9edc9", "#fefae0", "#faedcd", "#d4a373"]
    static let paletteSoftPastels = ["#cdb4db", "#ffc8dd", "#ffafcc", "#bde0fe", "#a2d2ff"]
    static let paletteRedVolcano = ["#003049", "#d62828", "#f77f00", "#fcbf49", "#eae2b7"]
    static let paletteSalmon = ["#f08080", "f#4978e", "#f8ad9d", "#fbc4ab", "#ffdab9"]
    static let paletteNeon = ["#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600"]
    static let paletteBlueYellow = ["#115f9a", "#22a7f0", "#76c68f", "#c9e52f", "#f4f100"]
    static let allPalettes = [paletteNeon, paletteRedVolcano, paletteSoftPastels, paletteBlueYellow, paletteVintage, paletteSalmon]
    
    static func getPaletteColor(_ index: Int) -> String {
        guard allPalettes.flatMap({ $0 }).count > 0 else {
            return "#ccd5ae"
        }

        let flatPalette = allPalettes.flatMap { $0 }
        let adjustedIndex = (index + flatPalette.count) % flatPalette.count
        return flatPalette[adjustedIndex]
    }
    
    static func getLinearGradient(color:String) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors:[Color(hex:color), Color(hex:color).darker(by:-40)]),
                    startPoint: .top,
                    endPoint: .bottom)
    }

}

#Preview {
    WaveformView(data: nil, width: 300, color: ColorUtil.getPaletteColor(4))
}
