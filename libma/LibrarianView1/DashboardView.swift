import SwiftUI

struct DashboardView: View {
    var body: some View {
        
        ZStack {
            Color(hex: 0xFFFFFF)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack (alignment: .top) {
                    VStack (alignment: .leading) {
                        Text("Hi , Xavier Welcome !")
                            .font(
                                Font.custom("SF Pro", size: 30)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top)
                        
                        Text("Top Genres")
                            .font(
                                Font.custom("SF Pro", size: 25)
                                    .weight(.light)
                            )
                            .foregroundColor(Constants.Black100)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding()
                        
                        HStack {
                            PieChartView(data: [
                                ("Action", 25.0, Color.blue),
                                ("Adventure", 20.0, Color.green),
                                ("Comedy", 15.0, Color.yellow),
                                ("Drama", 10.0, Color.orange),
                                ("Thriller", 30.0, Color.red)
                            ])
                            .frame(width: 210, height: 210)
                            .padding()
                            
                            Legend(data: [
                                ("Action", 25.0, Color.blue),
                                ("Adventure", 20.0, Color.green),
                                ("Comedy", 15.0, Color.yellow),
                                ("Drama", 10.0, Color.orange),
                                ("Thriller", 30.0, Color.red)
                            ])
                            .padding()
                            
                            HStack (alignment: .top) {
                                VStack {
                                    HStack {
                                        Image("borrow")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                            .padding()
                                        
                                        Text("Borrowed")
                                            .font(.custom("SF Pro", size: 20))
                                            .fontWeight(.semibold)
                                            .padding()
                                        
                                        Text("300")
                                            .font(.custom("SF Pro", size: 20))
                                            .fontWeight(.semibold)
                                            .padding()
                                    }
                                    
                                    HStack {
                                        Image("available")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                            .padding()
                                        
                                        Text("Available")
                                            .font(.custom("SF Pro", size: 20))
                                            .fontWeight(.semibold)
                                            .padding()
                                        
                                        Text("800")
                                            .font(.custom("SF Pro", size: 20))
                                            .fontWeight(.semibold)
                                            .padding()
                                    }
                                    
                                    HStack {
                                        Image("member")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                            .padding()
                                        
                                        Text("Members")
                                            .font(.custom("SF Pro", size: 20))
                                            .fontWeight(.semibold)
                                            .padding()
                                        
                                        Text("100")
                                            .font(.custom("SF Pro", size: 20))
                                            .fontWeight(.semibold)
                                            .padding()
                                    }
                                }
                            }
                            .padding(.leading, 180)
                            .padding(.top, -200)
                        }
                        
                        Text("Trending Now")
                            .font(
                                Font.custom("SF Pro Rounded", size: 28)
                                    .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                            .padding(.top)
                            .padding(.leading, 10)
                    }
                    .padding(.leading, 40)
                    .frame(width: 900, alignment: .leading)
                }
                
                HStack {
                    HStack (spacing: -45) {
                        Text("1")
                            .font(
                                Font.custom("Inter", size: 136)
                                    .weight(.heavy)
                            )
                        
                        VStack {
                            Image("book11")
                                .resizable()
                                .frame(width: 112, height: 159)
                                .padding()
                        }
                        
                    }
                    
                    HStack (spacing: -45) {
                        Text("2")
                            .font(
                                Font.custom("Inter", size: 136)
                                    .weight(.heavy)
                            )
                        
                        Image("book22")
                            .resizable()
                            .frame(width: 103, height: 145)
                            .padding()
                    }
                    
                    HStack (spacing: -45) {
                        Text("3")
                            .font(
                                Font.custom("Inter", size: 136)
                                    .weight(.heavy)
                            )
                        
                        Image("book33")
                            .resizable()
                            .frame(width: 112, height: 159)
                            .padding()
                    }
                    
                    HStack (spacing: -45) {
                        Text("4")
                            .font(
                                Font.custom("Inter", size: 136)
                                    .weight(.heavy)
                            )
                        
                        Image("book11")
                            .resizable()
                            .frame(width: 112, height: 159)
                            .padding()
                    }
                    
                    HStack (spacing: -45) {
                        Text("5")
                            .font(
                                Font.custom("Inter", size: 136)
                                    .weight(.heavy)
                            )
                        
                        Image("book33")
                            .resizable()
                            .frame(width: 112, height: 159)
                            .padding()
                    }
                    
                    Button(action: {
                        // Add action here
                    }) {
                        Text("See All")
                            .font(.custom("SF Pro", size: 20))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                }
                .padding(.trailing, -160)
                
                VStack (alignment: .leading) {
                    HStack {
                        Text("Overdue book loans ")
                            .font(
                                Font.custom("SF Pro Rounded", size: 28)
                                    .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                            .padding(.top, -10)
                            .padding(.leading, -30)
                        
                        Button(action: {
                            // Add action here
                        }) {
                            Text("See All")
                                .font(
                                    Font.custom("SF Pro Rounded", size: 23)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                                .padding(.top, -10)
                                .padding(.horizontal, 80)
                        }
                    }
                    
                    
                    VStack {
                        HStack {
                                Text("ID")
                                    .frame(width: 80, alignment: .leading)
                                    .bold()
                                Text("User Name")
                                    .frame(width: 100, alignment: .leading)
                                    .bold()
                                Text("Book Title")
                                    .frame(width: 150, alignment: .leading)
                                    .bold()
                                Text("Author")
                                    .frame(width: 150, alignment: .leading)
                                    .bold()
                                Text("ISBN")
                                    .frame(width: 90, alignment: .leading)
                                    .bold()
                                Text("Due Status")
                                    .frame(width: 70, alignment: .leading)
                                    .bold()
                                Text("Lend Date")
                                    .frame(width: 80, alignment: .leading)
                                    .bold()
                                Text("Return Date")
                                    .frame(width: 80, alignment: .leading)
                                    .bold()
                                Text("View")
                                    .frame(width: 50, alignment: .center)
                                    .bold()
                            }
                            .padding(.vertical, 5)
                            .padding(.trailing, 440)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                TableView()
                                TableView()
                                TableView()
                                TableView()

                            }
                            .padding()
                        }
                        .padding(.leading, -435)
                    }
                    .padding()
                }
                .padding(.leading,640)
            }
            
            
            
        }
        .overlay(
            TabBar()
                .position(x: 450, y:500)
        )
    }
}

struct Constants {
  static let unnamed: CGFloat = 8
    static let Black100: Color = Color(red: 0.11, green: 0.11, blue: 0.11)

}

struct PieChartView: View {
    var data: [(String, Double, Color)]
    
    var body: some View {
        VStack {
            PieChart(data: data)
                .aspectRatio(1, contentMode: .fit)
                .padding()
        }
    }
}

struct PieChart: View {
    var data: [(String, Double, Color)]
    var total: Double {
        data.map { $0.1 }.reduce(0, +)
    }

    let innerRadiusRatio: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PieSliceView(
                        startAngle: angle(at: index, in: data),
                        endAngle: angle(at: index + 1, in: data),
                        color: data[index].2
                    )
                }
                
                Circle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * innerRadiusRatio, height: geometry.size.height * innerRadiusRatio)
            }
        }
    }
    
    private func angle(at index: Int, in data: [(String, Double, Color)]) -> Angle {
        let sum = data.prefix(index).map { $0.1 }.reduce(0, +)
        return .degrees(sum / total * 360)
    }
}

struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)
        }
    }
}

struct Legend: View {
    var data: [(String, Double, Color)]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(data, id: \.0) { item in
                HStack {
                    ColorSwatch(color: item.2)
                    Text(item.0)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ColorSwatch: View {
    var color: Color
    
    var body: some View {
        color
            .frame(width: 12, height: 12)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
    }
}

struct TableView: View {
    var body: some View {
        HStack {
            Text("1234567")
                .frame(width: 80, alignment: .leading)
            Text("ZULMA CARY")
                .frame(width: 100, alignment: .leading)
            Text("QUANTUM COMPUT...")
                .frame(width: 150, alignment: .leading)
            Text("CHRIS BERNHARDT")
                .frame(width: 150, alignment: .leading)
            Text("XXXXXX")
                .frame(width: 90, alignment: .leading)
            Text("2 days")
                .frame(width: 90, alignment: .leading)
            Text("Mar 15")
                .frame(width: 70, alignment: .leading)
            Text("Mar 17")
                .frame(width: 80, alignment: .leading)
            Image(systemName: "eye")
                .frame(width: 50, alignment: .center)
        }
        .padding(.vertical, 5)
        .padding()
    }
}


#Preview {
    DashboardView()
}
