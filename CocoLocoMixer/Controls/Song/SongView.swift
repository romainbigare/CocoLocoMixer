import SwiftUI
struct SongView: View {
    @ObservedObject var song: Song

    init(song: Song) {
        self.song = song
    }

    var body: some View {
        let width = AppSettings.SecondsToScreen(for: song.duration, fallback: 300)
        WaveformView(data: song.waveformData,
                     width: width,
                     color: song.color)
            .frame(width: width, height: AppSettings.waveformHeight)
    }
}
