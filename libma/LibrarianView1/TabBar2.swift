//
//  TabBar2.swift
//  libma
//
//  Created by Yuvraj Pandey on 06/05/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct TabBar2: View {
    @State private var selectedIndex = 7
    @State var requests : Loan
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
                        TabBarButton(imageName: "square.grid.2x2", text: "Dashboard", index: 7, selectedIndex: $selectedIndex)
                       
                        // Book Status Button
                        TabBarButton(imageName: "paperplane", text: "Request", index: 8, selectedIndex: $selectedIndex)
                       
                        // Inventory Button
                        TabBarButton(imageName: "books.vertical", text: "Inventory", index: 9, selectedIndex: $selectedIndex)
                       
                        // Members Button
                        TabBarButton(imageName: "person.2", text: "Members", index: 10, selectedIndex: $selectedIndex)
                       
                        TabBarButton(imageName: "square.and.arrow.down.on.square", text: "Returns", index: 11, selectedIndex: $selectedIndex)
                       
                        // Notifications Button
                        TabBarButton(imageName: "book.and.wrench", text: "New Books", index: 12, selectedIndex: $selectedIndex)
                       
                        // Settings Button
                        TabBarButton(imageName: "doc.badge.plus", text: "Add Books", index: 13, selectedIndex: $selectedIndex)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .padding(.leading, -45)
            Spacer()
           
            GeometryReader{_ in
               
                VStack{
                   
                    // changing tabs based on tabs...
                    if self.selectedIndex == 7{
                       
                        DashboardPage2()
                    }
                    else if self.selectedIndex == 8{
                       
//                        AdminFunctionsFinal()
                        BooksLendingRequestView()
                    }
                    else if self.selectedIndex == 9{
                       
//                        BookTableView()
                        InventoryBookView()
                    }
                    else if self.selectedIndex == 10{
                       
                       
                        UserListView3()
                    }
                    else if self.selectedIndex == 11{
                       
//                        LoanView()
                        BooksReturnRequestView(requests: [])
                    }
                    else if self.selectedIndex == 12{
                       
                        NewbookRequestView()
                    }
                    else{
                       
                          AddBookView()
                    }
                   
                }
            }
        }
    }
}

struct TabBar2_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock instance of Loan with appropriate values
        let loan = Loan(
            id: nil,
            book_ref_id: "123",
            lending_date: Timestamp(date: Date()),
            due_date: Timestamp(date: Date()),
            user_id: "user123",
            penalty_amount: 10,
            library_id: 1,
            loan_status: "Active"
        )
                
        // Pass the mock instance to TabBar2
        TabBar2(requests: loan)
    }
}


