import SwiftUI
import Foundation

struct PopupAddView: View {
    @Binding var isShowingPopup: Bool
    @State var hasAppeared: Bool = false
    @Binding var isShowingPopupSearch:Bool // State variable for the search popup
    @StateObject var track : Track
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 10) {
                    PopupAddLine(
                        imageName: "icloud.circle.fill",
                        title: "From Spotify"
                    )
                    .onTapGesture {
                            // Handle action for "From Spotify"
                        let url1 = "https://www.dropbox.com/s/dl/620qqip91g6td9t/Double%20Violin%20Concerto%201st%20Movement%20-%20J.S.%20Bach.mp3"
                        
                        track.addSong(url: url1, color: ColorUtil.getPaletteColor(1))
                    }
                    
                    PopupAddLine(
                        imageName: "magnifyingglass.circle.fill",
                        title: "From Title Search"
                    )
                     .onTapGesture {
                            // Handle action for "From Title Search"
                            isShowingPopupSearch.toggle()
                            isShowingPopup.toggle()
                        }
                    
                    PopupAddLine(
                        imageName: "clock.fill",
                        title: "From Last Played"
                    )
                        .onTapGesture {
                            // Handle action for "From Last Played"
                            // For demonstration purpose, you can simply close the popup
                            isShowingPopup.toggle()
                        }
                }
                .padding()
                .background(Color.white).opacity(0.85)
                .cornerRadius(20)
                .padding(25)
            }
            .offset(y: hasAppeared ? -90 : -90)
            .onAppear {
                withAnimation {
                    self.hasAppeared.toggle()
                }
            }
        }
    }
}

struct PopupAddLine: View {
    var imageName: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.blue)
                .padding(.trailing)
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
    }
}


#Preview {
    HomeView()
} 
