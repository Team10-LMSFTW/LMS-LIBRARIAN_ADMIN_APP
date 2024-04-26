import SwiftUI
import Firebase
import FirebaseFirestore

class GlobalAppState: ObservableObject, Codable {
    @Published var user_id = ""
    @Published var library_id = ""
    @Published var isLoggedIn = false
    @Published var first_name = ""
    @Published var last_name = ""
    @Published var category = ""
    
    init() {}

    private enum CodingKeys: String, CodingKey {
        case user_id, library_id, isLoggedIn, first_name, last_name, category
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try container.decode(String.self, forKey: .user_id)
        library_id = try container.decode(String.self, forKey: .library_id)
        isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
        first_name = try container.decode(String.self, forKey: .first_name)
        last_name = try container.decode(String.self, forKey: .last_name)
        category = try container.decode(String.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(library_id, forKey: .library_id)
        try container.encode(isLoggedIn, forKey: .isLoggedIn)
        try container.encode(first_name, forKey: .first_name)
        try container.encode(last_name, forKey: .last_name)
        try container.encode(category, forKey: .category)
    }
    
    let db = Firestore.firestore()
    
    func saveUserToFirestore() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user signed in.")
            return
        }
        
        let userData: [String: Any] = [
            "user_id": currentUser.uid,
            "library_id": library_id,
            "isLoggedIn": isLoggedIn,
            "first_name": first_name,
            "last_name": last_name,
            "category": category
        ]
        
        db.collection("users").document(currentUser.uid).setData(userData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("User document added with ID: \(currentUser.uid)")
            }
        }
    }
}
