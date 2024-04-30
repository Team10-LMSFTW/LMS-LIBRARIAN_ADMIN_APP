import SwiftUI

struct TabBar: View {
    @State private var selectedIndex = 0
    
    var body: some View {
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
                    TabBarButton(imageName: "arrow.triangle.2.circlepath", text: "Book Status", index: 1, selectedIndex: $selectedIndex)
                    
                    // Inventory Button
                    TabBarButton(imageName: "books.vertical", text: "Inventory", index: 2, selectedIndex: $selectedIndex)
                    
                    // Members Button
                    TabBarButton(imageName: "person.2", text: "Members", index: 3, selectedIndex: $selectedIndex)
                    
                    Spacer()
                    
                    // Notifications Button
                    TabBarButton(imageName: "bell", text: "Notifications", index: 4, selectedIndex: $selectedIndex)
                    
                    // Settings Button
                    TabBarButton(imageName: "gearshape", text: "Settings", index: 5, selectedIndex: $selectedIndex)
                }
                .padding()
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
