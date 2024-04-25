//
//  libmaApp.swift
//  libma
//
//  Created by pushkar dada the og on 24/04/24.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("🔥 connected to firebase")
    return true
  }
}

@main
struct libmaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

public class FirestoreManager{
//    var user : AppUserState = AppUserState(login_status: false, cateogry: "none", first_name: "", last_name: "", library_id: "")
    let db = Firestore.firestore()

//    utility
    func fetchDocument(from collection: String, with documentID: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
      db.collection(collection).document(documentID).getDocument { (documentSnapshot, error) in
        if let error = error {
          completion(nil, error)
          return
        }
        completion(documentSnapshot, nil)
      }
    }

    public func login(email : String , password : String  , segment : Int , isLoggedIn : Binding<Bool>  ) {
        
        
        let category : String = segment == 0 ? "admin" : "librarian"
        print(email,password , category)
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] result, error in
              if let error = error {
                print("Sign-in error:", error.localizedDescription)
              } else {
                // Handle successful sign-in (e.g., navigate to a different view)
                print("User signed in successfully!")
                  print(result!.user.uid)
                  
                  
                  db.collection("users").document(result!.user.uid).getDocument { (documentSnapshot, error) in
                    if let error = error {
                        print(error)
                      return
                    }else{
                        print()
                        if( documentSnapshot!.data()!["category_type"]! as! String == category){
                            
                    }
                    }
                  }

              }
            }
        
    }

//    public func login(email: String, password: String, segment: Int) async -> (success: Bool, category: String?) {
//      let category = segment == 0 ? "admin" : "librarian"
//      print(email, password, category)
//
//      return await withUnsafeContinuation { continuation in
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//          if let error = error {
//            print("Sign-in error:", error.localizedDescription)
//            continuation.resume(returning: (false, nil))
//            return
//          }
//
//          print("User signed in successfully!")
//          print(result!.user.uid)
//
//            let docRef = self.db.collection("users").document(result!.user.uid)
//          docRef.getDocument { (documentSnapshot, error) in
//            if let error = error {
//              print(error)
//              continuation.resume(returning: (false, nil))
//              return
//            } else {
//              guard let document = documentSnapshot, document.exists else {
//                print("User document not found")
//                continuation.resume(returning: (false, nil))
//                return
//              }
//
//              let data = document.data()!
//              if data["category_type"] as! String == category {
//                continuation.resume(returning: (true, category))
//              } else {
//                continuation.resume(returning: (true, nil)) // Login successful, but category mismatch
//              }
//            }
//          }
//        }
//      }
//    }

}

public struct AppUserState {
    var login_status : Bool;
    var cateogry : String;
    var first_name : String;
    var last_name : String;
    var library_id : String
    
}
