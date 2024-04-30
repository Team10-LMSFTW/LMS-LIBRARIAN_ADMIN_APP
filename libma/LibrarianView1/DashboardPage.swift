import SwiftUI
import Charts

struct DashboardPage: View {
    
    @State private var progress: CGFloat = 0.7 // Example progress
    
    var body: some View {
        HStack {
            // TabBar on the left side
            TabBar()
            
            // Content area
            ZStack {
                Color(hex: 0xFFFFFF)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Dashboard")
                            .font(
                                Font.custom("SF Pro", size: 35)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding()
                        
                        HStack(spacing: 35) {
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

                            
                            Spacer()
                            Spacer()
                        }
                        .padding()
                        
                        // Your other content here
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Book Ring")
                                    .font(
                                        Font.custom("SF Pro", size: 35)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                                    .padding()
                                
                                Button(action: {
                                    // Action to perform when the button is tapped
                                    // You can put your action here
                                }) {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(red: 0.94, green: 0.92, blue: 1))
                                        .cornerRadius(20)
                                        .frame(width: 381, height: 317)
                                        .padding(.leading)
                                        .overlay(
                                            VStack {
                                                CircularProgress(progress: progress)
                                            }
                                        )
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                HStack (spacing: 350) {
                                    Text("Top Books")
                                        .font(
                                            Font.custom("SF Pro", size: 35)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.black)
                                        .padding()
                                    
                                    Button(action: {
                                        // Action to perform when the button is tapped
                                        // You can put your action here
                                    }) {
                                        Text("See all")
                                            .font(
                                                Font.custom("SF Pro", size: 28)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                }
                                
                                Rectangle()
                                .foregroundColor(.clear)
                                .background(Color(red: 0.94, green: 0.92, blue: 1))
                                .cornerRadius(20)
                                .frame(width: 650, height: 317)
                                .padding(.leading)
                                .padding(.trailing, 80)
                                .overlay (
                                    VStack (alignment: .leading) {
                                        HStack {
                                            HStack (spacing: -45) {
                                                Text("1")
                                                    .font(
                                                        Font.custom("Inter", size: 140)
                                                            .weight(.heavy)
                                                    )
                                                
                                                VStack {
                                                    Image("book11")
                                                        .resizable()
                                                        .frame(width: 122, height: 179)
                                                        .padding()
                                                }
                                                
                                            }
                                            
                                            HStack (spacing: -45) {
                                                Text("2")
                                                    .font(
                                                        Font.custom("Inter", size: 140)
                                                            .weight(.heavy)
                                                    )
                                                
                                                Image("book22")
                                                    .resizable()
                                                    .frame(width: 113, height: 155)
                                                    .padding()
                                            }
                                            
                                            HStack (spacing: -45) {
                                                Text("3")
                                                    .font(
                                                        Font.custom("Inter", size: 140)
                                                            .weight(.heavy)
                                                    )
                                                
                                                Image("book33")
                                                    .resizable()
                                                    .frame(width: 122, height: 169)
                                                    .padding()
                                            }
                                        }
                                        .padding(.leading, -50)
                                        .padding()
                                    }
                                )

                            }
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Analysis")
                                .font(
                                    Font.custom("SF Pro", size: 35)
                                        .weight(.bold)
                                )
                                .foregroundColor(.black)
                                .padding(.leading, 35)
                            
                            VStack {
                                HStack {
                                    HStack {
                                        
                                        Rectangle()
                                          .foregroundColor(.clear)
                                          .frame(width: 542, height: 317)
                                          .background(Color(red: 0.94, green: 0.92, blue: 1))
                                          .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("New Member")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                    
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                .padding()
                                            )
                                        
                                    }
                                    .padding()
                                    
                                    HStack {
                                        
                                        Rectangle()
                                          .foregroundColor(.clear)
                                          .frame(width: 542, height: 317)
                                          .background(Color(red: 0.94, green: 0.92, blue: 1))
                                          .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("New Books")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                    
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                .padding()
                                            )
                                        
                                    }
                                    .padding()
                                    
                                    
                                }
                                .padding()
                                
                                HStack {
                                    HStack {
                                        
                                        Rectangle()
                                          .foregroundColor(.clear)
                                          .frame(width: 542, height: 317)
                                          .background(Color(red: 0.94, green: 0.92, blue: 1))
                                          .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("Fines Overdue")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                    
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                .padding()
                                            )
                                        
                                    }
                                    .padding()
                                    
                                    HStack {
                                        
                                        Rectangle()
                                          .foregroundColor(.clear)
                                          .frame(width: 542, height: 317)
                                          .background(Color(red: 0.94, green: 0.92, blue: 1))
                                          .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("Membership Rate")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                    
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                .padding()
                                            )
                                        
                                    }
                                    .padding()
                                    
                                    
                                }
                                .padding()

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
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 30))
                .frame(width: 200, height: 200)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 30))
                .foregroundColor(.black)
                .bold()
        }
    }
}

struct GraphCardView: View {
    var title: String
    var data: [ChartData]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Chart {
                ForEach(data, id: \.id) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 100)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct ChartData {
    let id: Int
    let date: Date
    let value: Double
}

let sampleData: [ChartData] = [
    ChartData(id: 0, date: Date().addingTimeInterval(-2400 * 5), value: 1),
    ChartData(id: 1, date: Date().addingTimeInterval(-2400 * 4), value: 3),
    ChartData(id: 2, date: Date().addingTimeInterval(-2400 * 3), value: 2),
    ChartData(id: 3, date: Date().addingTimeInterval(-2400 * 2), value: 5),
    ChartData(id: 4, date: Date().addingTimeInterval(-2400 * 1), value: 4)
]

#Preview {
    DashboardPage()
}
