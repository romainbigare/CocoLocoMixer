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
}

let paletteVintage = ["#ccd5ae", "#e9edc9", "#fefae0", "#faedcd", "#d4a373"]
let paletteSoftPastels = ["#cdb4db", "#ffc8dd", "#ffafcc", "#bde0fe", "#a2d2ff"]
let paletteRedVolcano = ["#003049", "#d62828", "#f77f00", "#fcbf49", "#eae2b7"]
let paletteSalmon = ["#f08080", "f#4978e", "#f8ad9d", "#fbc4ab", "#ffdab9"]
let paletteNeon = ["#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600"]
let paletteBlueYellow = ["#115f9a", "#22a7f0", "#76c68f", "#c9e52f", "#f4f100"]

// Combine all palettes into a single list
let allPalettes = [paletteNeon, paletteRedVolcano, paletteSoftPastels, paletteBlueYellow, paletteVintage, paletteSalmon]

func getPaletteColor(_ index: Int) -> String {
    guard allPalettes.flatMap({ $0 }).count > 0 else {
        return "#ccd5ae"
    }

    let flatPalette = allPalettes.flatMap { $0 }
    let adjustedIndex = (index + flatPalette.count) % flatPalette.count
    return flatPalette[adjustedIndex]
}
