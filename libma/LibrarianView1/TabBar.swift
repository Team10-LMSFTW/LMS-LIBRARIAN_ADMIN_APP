import SwiftUI

struct TabBar: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack {
            Color(hex: 0xFFFFFF)
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 229, height: 1024)
                .background(Color(red: 0.96, green: 0.96, blue: 0.91))
            
            VStack {
                VStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 97, height: 91)
                        .background(
                            Image("PATH_TO_IMAGE")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 97, height: 91)
                                .clipped()
                        )
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(97)
                        .padding()
                    
                    Text("xavier123")
                        .font(
                            Font.custom("SF Pro", size: 20)
                                .weight(.semibold)
                        )
                        .foregroundColor(.black)
                        .frame(height: 22, alignment: .center)
                    
                    Text("Librarian")
                        .font(
                            Font.custom("SF Pro", size: 20)
                                .weight(.bold)
                        )
                        .foregroundColor(.black)
                        .frame(height: 22, alignment: .center)
                }
                .padding()

                VStack(alignment: .leading) {
                    
                    Button(action: {
                        self.selectedIndex = 0
                    }) {
                        HStack (spacing: 15) {
                            Image(systemName: "square.grid.2x2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedIndex == 0 ? .white : .black)
                            
                            Text("Dashboard")
                                .font(
                                    Font.custom("SF Pro", size: 25)
                                        .weight(.bold)
                                )
                                .foregroundColor(selectedIndex == 0 ? .white : .black)
                                .frame(width: 150)
                        }
                        .padding()
                        .background(selectedIndex == 0 ? Color(hex: 0x54408C) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        self.selectedIndex = 1
                    }) {
                        HStack (spacing: 15) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(selectedIndex == 1 ? .white : .black)
                            
                            Text("Book Status")
                                .font(
                                    Font.custom("SF Pro", size: 25)
                                        .weight(.bold)
                                )
                                .foregroundColor(selectedIndex == 1 ? .white : .black)
                                .frame(width: 150)

                        }
                        .padding()
                        .background(selectedIndex == 1 ? Color(hex: 0x54408C) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        self.selectedIndex = 2
                    }) {
                        HStack (spacing: 15) {
                            Image(systemName: "books.vertical")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(selectedIndex == 2 ? .white : .black)
                            
                            Text("Inventory")
                                .font(
                                    Font.custom("SF Pro", size: 25)
                                        .weight(.bold)
                                )
                                .foregroundColor(selectedIndex == 2 ? .white : .black)
                                .frame(width: 150)

                        }
                        .padding()
                        .background(selectedIndex == 2 ? Color(hex: 0x54408C) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        self.selectedIndex = 3
                    }) {
                        HStack (spacing: 15) {
                            Image(systemName: "person.2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(selectedIndex == 3 ? .white : .black)
                            
                            Text("Members")
                                .font(
                                    Font.custom("SF Pro", size: 25)
                                        .weight(.bold)
                                )
                                .foregroundColor(selectedIndex == 3 ? .white : .black)
                                .frame(width: 150)
                        }
                        .padding()
                        .background(selectedIndex == 3 ? Color(hex: 0x54408C) : Color.clear)
                        .cornerRadius(10)
                        
                    }
                    Spacer()
                }
                .padding()
            }
            .padding()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}








