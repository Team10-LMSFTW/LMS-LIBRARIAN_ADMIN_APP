import SwiftUI

struct DashboardPage: View {
    
    
    var body: some View {
        HStack {
            // TabBar on the left side
            TabBar()
            
            // Content area
            ZStack {
                Color(hex: 0xFFFFFF)
                    .edgesIgnoringSafeArea(.all)
                
                VStack (alignment: .leading) {
                    Text("Dashboard")
                        .font(
                            Font.custom("SF Pro", size: 35)
                                .weight(.bold)
                        )
                        .foregroundColor(.black)
                        .padding(.top)
                        .padding(.leading)
                        .padding()

                    HStack (spacing: 35) {
                        Button(action: {
                            // Action to perform when the button is tapped
                            // You can put your action here
                        }) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 249, height: 148)
                                .background(Color(red: 0.94, green: 0.92, blue: 1))
                                .cornerRadius(20)
                                .overlay(
                                    VStack (spacing: 20) {
                                        Text("Book Fines")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        
                                        Text("$438")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                                            .bold()
                                    }
                                    .padding()
                                )
                        }
                        
                        Button(action: {
                            // Action to perform when the button is tapped
                            // You can put your action here
                        }) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 249, height: 148)
                                .background(Color(red: 0.94, green: 0.92, blue: 1))
                                .cornerRadius(20)
                                .overlay(
                                    VStack (spacing: 20) {
                                        Text("Members")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        
                                        Text("13,542")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                                            .bold()
                                    }
                                    .padding()
                                )
                        }
                        
                        Button(action: {
                            // Action to perform when the button is tapped
                            // You can put your action here
                        }) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 249, height: 148)
                                .background(Color(red: 0.94, green: 0.92, blue: 1))
                                .cornerRadius(20)
                                .overlay(
                                    VStack (spacing: 20) {
                                        Text("Active User")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        
                                        Text("18%")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                                            .bold()
                                    }
                                    .padding()
                                )
                        }
                        
                        Button(action: {
                            // Action to perform when the button is tapped
                            // You can put your action here
                        }) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 249, height: 148)
                                .background(Color(red: 0.94, green: 0.92, blue: 1))
                                .cornerRadius(20)
                                .overlay(
                                    VStack (spacing: 20) {
                                        Text("Issues Raised")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        
                                        Text("7")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                                            .bold()
                                    }
                                    .padding()
                                )
                        }
                    }
                    .padding()
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Booking")
                                .font(
                                    Font.custom("SF Pro", size: 35)
                                        .weight(.bold)
                                )
                                .foregroundColor(.black)
                                .padding(.top)
                                .padding(.leading)
                                .padding()
                            
                            Button(action: {
                                // Action to perform when the button is tapped
                                // You can put your action here
                            }) {
                                Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(width: 521, height: 317)
                                  .cornerRadius(20)
                                    .overlay(
                                        VStack () {
                                            
                                            Circle()
                                                .stroke(lineWidth: 30.0)
                                                .opacity(0.3)
                                                .foregroundColor(Color.blue)
                                                .padding()
                                            
                                        }
                                        .padding()
                                    )
                            }
                        }
                        
                        
                        
                    }
                }
            }
        }
    }
}

struct CircularProgress: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 10))
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 20))
                .foregroundColor(.black)
                .bold()
        }
    }
}

#Preview {
    DashboardPage()
}
