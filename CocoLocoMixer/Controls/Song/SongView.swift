import SwiftUI

struct SongView: View {
    @StateObject private var songViewModel: SongViewModel
    let mp3Song: String // Property to store the MP3 song link
    let fillColorHex: String // Property to store the color string

    init(mp3Song: String, fillColorHex: String) {
        _songViewModel = StateObject(wrappedValue: SongViewModel(mp3Song: mp3Song))
        self.mp3Song = mp3Song
        self.fillColorHex = fillColorHex
    }

    var body: some View {
            ScrollView(.horizontal, showsIndicators: true) {
                WaveformView(viewModel: songViewModel, fillColorHex: fillColorHex)
                    .padding()
            }
        }
}


struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            //#d4afb9 // #d1cfe2 // #9cadce // #7ec4cf // #52b2cf
            SongView(mp3Song: "https://file-examples.com/storage/fed61549c865b2b5c9768b5/2017/11/file_example_MP3_5MG.mp3", fillColorHex: "#d4afb9")
            SongView(mp3Song: "your_song.mp3", fillColorHex: "#d1cfe2")
            SongView(mp3Song: "your_song.mp3", fillColorHex: "#9cadce")
            SongView(mp3Song: "your_song.mp3", fillColorHex: "#7ec4cf")
            SongView(mp3Song: "your_song.mp3", fillColorHex: "#52b2cf")
        }
    }
}

