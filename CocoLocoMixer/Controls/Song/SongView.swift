import SwiftUI

struct SongView: View {
    @StateObject var song: SongViewModel
    let url: String // Property to store the MP3 song link
    let color: String // Property to store the color string

    init(url: String, color: String) {
        _song = StateObject(wrappedValue: SongViewModel(url: url))
        self.url = url
        self.color = color
    }

    var body: some View {
        let width = AppSettings.SecondsToScreen(for: song.duration, fallback: 300)
        WaveformView(data: song.waveformData,
                     width: width,
                     color: color)
            .frame(width:width, height:AppSettings.waveformHeight)
    }
}
