//
//  ContentView.swift
//  libma
//
//  Created by mathangy on 24/04/24.
//

//import SwiftUI
//
//struct ContentView: View {
//    @State var isLoggedIn: Bool = false
//    @State var category: String = "none"
//    @StateObject var app_state = GlobalAppState()
//
//    var body: some View {
//        if !isLoggedIn {
//            LoginView(globalAppState: app_state, isLoggedIn: $isLoggedIn, category: $category)
//        } else {
//            if category == "Admin" {
//                AdminViewGroup()
//            } else {
//                LibrarianViewGroup()
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    @AppStorage("login_status") var loginStatus: Bool = false
    @State var isLoggedIn: Bool = false
    @State var category: String = "none"
    @StateObject var app_state = GlobalAppState()

    var body: some View {
    
                if !isLoggedIn {
                    LoginView(globalAppState: app_state, isLoggedIn: $isLoggedIn, category: $category)
                        .environmentObject(app_state)
                } else {
                    if category == "admin" {
                        AdminViewGroup()
                    } else {
//                        LibrarianViewGroup()
                       BooksInventoryView()
//                        DashboardView()
//                        AddBookView()
                    }
                }
            }
        }
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
