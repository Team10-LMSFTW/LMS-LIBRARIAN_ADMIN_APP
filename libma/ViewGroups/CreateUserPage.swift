import SwiftUI
import Firebase

struct CreateUserPage: View {
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedRole: String = ""
    @State private var selectedLibrary: String = ""
    @State private var libraries: [String] = [] // To store fetched library IDs
    
    let roles = ["Admin", "Librarian", "User"]
    @State private var showAlert: Bool = false // For showing alert

    var body: some View {
        VStack {
            Text("Create User")
                .font(.title)
                .padding()
            
            TextField("Email ID", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Text("Select Role")
                    .foregroundColor(.black)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("Select Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(.trailing)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Select Your Library")
                    .foregroundColor(.black)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("Select Your Library", selection: $selectedLibrary) {
                    ForEach(libraries, id: \.self) { library in
                        Text(library)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(.trailing)
            }
            .padding(.horizontal)
            
            Button("Create") {
                createUser()
                showAlert = true // Show alert after user creation
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            fetchLibraryIDs()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Great!"), message: Text("User is created with the assigned User Role"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func fetchLibraryIDs() {
        let db = Firestore.firestore()
        db.collection("librarians").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching library IDs: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No snapshot found")
                return
            }
            
            for document in snapshot.documents {
                if let libraryID = document.get("library_id") as? String {
                    libraries.append(libraryID)
                }
            }
        }
    }
    
    private func createUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document() // Create a new document reference with an auto-generated ID
        
        let userData: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "category": selectedRole, // Assign selected role
            "lib_id": selectedLibrary // Assign selected library
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                print("Error creating user: \(error)")
            } else {
                print("User created successfully")
                // Clear input fields after user creation
                email = ""
                firstName = ""
                lastName = ""
                selectedRole = ""
                selectedLibrary = ""
            }
        }
    }
}

struct CreateUserPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserPage()
    }
}
