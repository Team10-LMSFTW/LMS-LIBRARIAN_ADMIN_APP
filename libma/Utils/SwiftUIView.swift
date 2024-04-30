//
//  SwiftUIView.swift
//  libma
//
//  Created by admin on 30/04/24.
//

import SwiftUI
import Foundation


class AuthUtils {
    
    public func saveUserData(authID: String, isLoggedIn: Bool) {
      UserDefaults.standard.setValue(authID, forKey: "firebaseAuthID")
      UserDefaults.standard.setValue(isLoggedIn, forKey: "isLoggedIn")
    }




    public func retrieveUserData() -> (authID: String?, isLoggedIn: Bool) {
      let authID = UserDefaults.standard.string(forKey: "firebaseAuthID")
      let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
      return (authID, isLoggedIn)
    }


    public func logout() {
      UserDefaults.standard.removeObject(forKey: "firebaseAuthID")
      UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }

}
