import SwiftUI

struct TabBar: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 118, height: .infinity)
                  .background(Color(red: 0.96, green: 0.96, blue: 0.91))
                
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
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(97)
                        .padding()
                    
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
            .padding(.trailing, -56)
            Spacer()
            
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

struct TabBarButton: View {
    let imageName: String
    let text: String
    let index: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(selectedIndex == index ? Color(hex: 0x54408C) : Color.clear)
                .frame(width: selectedIndex == index ? 118 : 0, height: 90)
                .cornerRadius(10)
            
            Button(action: {
                self.selectedIndex = index
            }) {
                VStack (spacing: 15) {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedIndex == index ? .white : .black)
                    
                    Text(text)
                        .font(
                            Font.custom("SF Pro", size: 15)
                                .weight(.bold)
                        )
                        .foregroundColor(selectedIndex == index ? .white : .black)
                        .frame(width: 150)
                }
                .padding()
            }
        }
        .cornerRadius(10)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
