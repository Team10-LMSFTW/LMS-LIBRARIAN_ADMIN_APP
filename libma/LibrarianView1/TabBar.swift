import SwiftUI


struct TabBar: View {
    @State private var selectedIndex = 0
    @Environment(\.colorScheme) var colorScheme
    
    let cornerRadius : CGFloat = 15
    let mainColor = Color.Neumorphic.main
    let secondaryColor = Color.Neumorphic.secondary
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                .edgesIgnoringSafeArea(.all)
            
            HStack (spacing: -15) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "F0F1F5") : UIColor(hex: "323345")))
                        .frame(width: 118, height: .infinity)
                        .ignoresSafeArea()
                        .shadow(color: .black.opacity(0.2), radius: 15, x: 5, y: 5).blur(radius: 1)
                    
                    
                    VStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 68, height: 67)
                            .background(
                                Image("PATH_TO_IMAGE")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 68, height: 67)
                                    .clipped()
                            )
                            .padding()
//                            .overlay(
//                                VStack {
//                                    Button(action: {
//                                        // Action to perform the theme change of bg to 323345 and upon again it should go back to original color F1F2F7
//                                    }) {
//                                        Image(systemName: "circle.lefthalf.filled")
//                                            .resizable()
//                                            .frame(width: 25, height: 25)
//                                            .foregroundColor(Color(hex: 0x181724))
//                                            .padding(.top, 65)
//                                            .padding(.leading, 45)
//                                    }
//                                }
//                                    .padding()
//                            )
                        
                        
                        VStack(alignment: .leading) {
                            // Dashboard Button
                            TabBarButton(imageName: "square.grid.2x2", text: "Dashboard", index: 0, selectedIndex: $selectedIndex)
                            
                            // Book Status Button
                            TabBarButton(imageName: "house", text: "Home", index: 1, selectedIndex: $selectedIndex)
                            
                            // Inventory Button
                            TabBarButton(imageName: "books.vertical", text: "Inventory", index: 2, selectedIndex: $selectedIndex)
                            
                            // Members Button
                            TabBarButton(imageName: "person.2", text: "Members", index: 3, selectedIndex: $selectedIndex)
                            
                            TabBarButton(imageName: "indianrupeesign.circle", text: "Fines", index: 4, selectedIndex: $selectedIndex)
                            
                            Spacer()
                            
                            // Notifications Button
                            TabBarButton(imageName: "bell", text: "Notifications", index: 5, selectedIndex: $selectedIndex)
                            
                            // Settings Button
                            TabBarButton(imageName: "gearshape", text: "Settings", index: 6, selectedIndex: $selectedIndex)
                        }
                        .padding()
                    }
                }
                .padding(.leading, -45)
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        // changing tabs based on tabs...
                        if self.selectedIndex == 0{
                            
                            DashboardPage()
                        }
                        else if self.selectedIndex == 1{
                            
                            AdminFunctionsFinal()
                        }
                        else if self.selectedIndex == 2{
                            
                            BookTableView()
                        }
                        else if self.selectedIndex == 3{
                            
                            UserListView3()
                        }
                        else if self.selectedIndex == 4{
                            
                            LoanView()
                        }
                        else if self.selectedIndex == 5{
                            
                            NotificationsPage()
                        }
                        else{
                            
                            SettingsPage()
                        }
                        
                    }
                }
            }
        }
    }
}

struct TabBarButton: View {
    let imageName: String
    let text: String
    let index: Int
    @Binding var selectedIndex: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: selectedIndex == index ? 115 : 0, height: 90)
                .foregroundColor(colorScheme == .light ? Color(UIColor(hex: "F1F2F7")) : Color(UIColor(hex: "323345")))
                .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
            
            
            
            
            Button(action: {
                self.selectedIndex = index
            }) {
                VStack(spacing: 15) {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedIndex == index ? Color(hex: "E082A1") : Color(hex: "B3B3BD"))
                    
                    Text(text)
                        .font(Font.custom("SF Pro", size: 15).weight(.bold))
                        .foregroundColor(selectedIndex == index ? colorScheme == .dark ? Color.white : Color.black : Color(hex:"B3B3BC"))
                        .frame(width: 150)
                }
                .padding()
            }
            
            
            
            
            
            
            
        }
        .cornerRadius(10)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
