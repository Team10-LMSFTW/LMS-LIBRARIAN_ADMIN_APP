//
//  ContentView.swift
//  libma
//
//  Created by mathangy on 24/04/24.
//

import SwiftUI

struct ContentView: View {
//    @AppStorage("login_status") var loginStatus : Bool = false
    
    @State var  isLoggedIn : Bool = false;
    @State var category : String = "none"
    
    @StateObject public var app_state = GlobalAppState()

    var body: some View {
        
        if(!isLoggedIn){                LoginView(globalAppState: app_state, isLoggedIn:$isLoggedIn ,category:$category)
            }else{
                if(category == "admin"){
                    AdminViewGroup()
                }else{
                    LibrarianViewGroup()
                }
            }
        }
    
}

#Preview {
    ContentView()
}
