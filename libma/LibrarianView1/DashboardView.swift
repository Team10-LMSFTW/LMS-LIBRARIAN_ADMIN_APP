import SwiftUI

struct DashboardView: View {
    var body: some View {
        ZStack {
            Color(hex: 0xFFFFFF)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    VStack {
                        Text("Hi , Xavier Welcome !")
                          .font(
                            Font.custom("Poppins", size: 20)
                              .weight(.semibold)
                          )
                          .foregroundColor(.black)
                          .frame(width: 221, height: 26, alignment: .topLeading)
                        
                        Text("Top Genres")
                          .font(
                            Font.custom("Inter", size: 14)
                              .weight(.semibold)
                          )
                          .foregroundColor(Constants.Black100)
                          .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                    }
                    .padding(0)
                    .frame(width: 384, alignment: .leading)
                .cornerRadius(Constants.unnamed)
                }
                
                .overlay(
                    TabBar()
                        .position(x:-370)
                )
            }
        }
    }
}

struct Constants {
  static let unnamed: CGFloat = 8
    static let Black100: Color = Color(red: 0.11, green: 0.11, blue: 0.11)

}

#Preview {
    DashboardView()
}
