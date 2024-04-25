//
//  DataModelUser.swift
//  libma
//
//  Created by admin on 25/04/24.
//

import SwiftUI

class GlobalAppState: ObservableObject {
      @Published public var user_id = ""
      @Published public var library_id = ""
      @Published public  var isLoggedIn = false
      @Published public var first_name = ""
    @Published public  var last_name = ""
    @Published public var category = ""


//  func login(email: String, password: String, segment: Int) {
//    // Replace this logic with your actual login functionality (e.g., calling a service)
//    isLoggedIn = true // Simulate successful login for now
//    errorMessage = ""
//  }
}
