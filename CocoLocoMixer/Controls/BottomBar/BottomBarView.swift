
import SwiftUI


struct BottomBar: View {
    @Binding var isShowingPopupAdd: Bool
    @Binding var isPlaying: Bool
    
    var body: some View {

        HStack(spacing: 10){
            //Home
            Button {
                isPlaying.toggle()
            } label: {
                ZStack{
                    BottomBarButtonView(
                        image: isPlaying ? "pause.circle" : "play.circle",
                        text: isPlaying ? "Pause" : "Play"
                    )
                }
            }
            
            //Search
            Button {
                // do something
                } label: {
                    BottomBarButtonView(
                        image: "magnifyingglass",
                        text: "Zoom"
                    )
                }
                
                Button {
                    isShowingPopupAdd.toggle()

                } label: {
                    VStack{
                        ZStack{
                            VStack(spacing: 3){
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 60,height: 60)
                                    .foregroundColor(.purple)
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            .mask(RoundedRectangle(cornerRadius: 30))
                                    )
                                
                            }
                            VStack(spacing: 3){
                                Image(systemName: "plus").font(.title).foregroundColor(.white).scaleEffect(1.4)
                                
                            }
                        }.padding(EdgeInsets(top: -23, leading: 0, bottom: 0, trailing: 0))
                            Spacer()
                                                
                    }
                }.scaleEffect(1.1)
                //Notification
                Button {
                    // do something
                } label: {
                    BottomBarButtonView(
                        image: "square.and.arrow.down",
                        text: "Export"
                    )
                }
                //Profile
                Button {
                    // do something
                } label: {
                    
                    BottomBarButtonView(
                        image: "gear",
                        text: "Settings")
                }
            }
            .frame(height: 40)
           // .shadow(color: Color.white.opacity(1), radius: 10, x: 0,y: 0)
            .padding(.vertical)
        
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        return HomeView()
    }
}

struct BottomBarButtonView: View {
    
    var image:String
    var text:String
    
    var body: some View {
        HStack(spacing: 10){
            VStack(spacing: 3){
                Rectangle()
                    .frame(height: 0)
                Image(systemName:image)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.white)
                Text(text)
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            
        }
    }
}
