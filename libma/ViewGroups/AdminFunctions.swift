import SwiftUI
import Firebase

struct AdminFunctionsFinal: View {
    @State private var users: [UserData2] = []
    @State private var selectedLibrary: String = ""
    @State private var fineAmount: String = ""
    @State private var libraryID: String = ""
    @State private var libraries: [String] = [] // To store fetched library IDs
    @State private var fineRate: Int = 0 // To store the new fine rate/ To store the new fine rate
    @State private var showAlert: Bool = false // For showing alert
    @State private var adminEmail: String = ""
    @State private var fineRateInput: String = ""
    @State private var isCreateUserPagePresented = false

    
    var body: some View {
        VStack {
            // Card 1: User List
            Card1 {
                VStack(alignment:.center) {
                    HStack {
                        Text("User List")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                        
                        Button(action: {
                            isCreateUserPagePresented.toggle()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25) // Set the size here
                                .foregroundColor(.black)
                                .padding()
                        }
                        .padding()
                        .sheet(isPresented: $isCreateUserPagePresented) {
                            NavigationView {
                                CreateUserPage()
                                    .navigationBarTitle("Create User", displayMode: .inline)
                                    .navigationBarItems(leading: Button("Back") {
                                        isCreateUserPagePresented.toggle()
                                    })
                            }
                        }
                    }
                    
                    
                    // Table headers
                    HStack (spacing: 160) {
                        Text("Name")
//                        Spacer()
                        Text("Category")
//                        Spacer()
                        Text("Email")
//                        Spacer()
                        Text("Library ID")
//                        Spacer()
                        Text("Membership Type")
//                        Spacer()
                        Text("Rating")
                    }
                    .padding(.horizontal)
                    .font(.headline)
                    
                    List(users) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(user.firstName ?? "N/A") \(user.lastName ?? "N/A")")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Text(user.categoryType ?? "N/A")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            Text(user.email ?? "N/A")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            Text(user.libraryID ?? "N/A")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            Text(user.membershipType ?? "N/A")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            Text(user.rating.map { "\($0)" } ?? "N/A")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.5)
            
            // Cards 2 & 3: Fine Rates & Create Library
            HStack {
                // Card 2: Fine Rates
                CardView(title: "Fine Rates", content: {
                    VStack {
                        // "Library ID" text
                        Text("Library ID")
                            .font(.headline)
                            .padding(.top)
                        
                        // Dropdown Picker for Libraries
                        Picker("Select Library", selection: $selectedLibrary) {
                            ForEach(libraries, id: \.self) { library in
                                Text(library)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color.blue) // Change the color of the picker
                        .onAppear {
                            fetchLibraryIDs()
                        }
                        
                        // Text Field for New Fine Rate
                        TextField("New Fine Rate", text: $fineAmount)
                            .keyboardType(.numberPad)
                            .padding()
                        
                        // Button to Update Fine Rate
                        Button(action: {
                            updateFineRate()
                            showAlert = true // Show the alert when fine rate is updated
                        }) {
                            Text("Update Fine Rate")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                })
                .padding()
                
                // Card 3: Create Library
                CardView(title: "Create Library", content: {
                    VStack {
                        // Text Field for Admin Email
                        TextField("Admin Email", text: $adminEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        // Text Field for Fine Rate
                        TextField("Fine Rate", text: $fineRateInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        // Button to Create Library
                        Button(action: {
                            createLibrary()
                        }) {
                            Text("Create Your Library")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Congratulations!"), message: Text("Your new Library is created"), dismissButton: .default(Text("OK")))
                        }
                    }
                })
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fine Rate Updated"), message: Text("The fine rate has been updated successfully for library ID: \(selectedLibrary)"), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Fetch data from Firebase Firestore initially
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("users")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                var fetchedUsers: [UserData2] = []
                
                for document in documents {
                    var user = UserData2(id: document.documentID)
                    
                    user.categoryType = document.get("category_type") as? String
                    user.email = document.get("email") as? String
                    user.firstName = document.get("first_name") as? String
                    user.lastName = document.get("last_name") as? String
                    user.libraryID = document.get("library_id") as? String
                    user.membershipType = document.get("membership_type") as? String
                    user.rating = document.get("rating") as? Int
                    
                    fetchedUsers.append(user)
                }
                
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                }
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
    
    private func updateFineRate() {
        let db = Firestore.firestore()
        db.collection("librarys").document(selectedLibrary).updateData(["fine_rate": Int(fineAmount) ?? 0]) { error in
            if let error = error {
                print("Error updating fine rate: \(error)")
            } else {
                print("Fine rate updated successfully for library ID: \(selectedLibrary)")
                showAlert=true
            }
        }
    }
    
    private func createLibrary() {
        let db = Firestore.firestore()
                let libraryDocumentsRef = db.collection("librarys")

                libraryDocumentsRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching library documents: \(error)")
                        return
                    }

                    // Get the latest document ID
                    var latestDocumentID = 0
                    for document in querySnapshot!.documents {
                        let documentID = Int(document.documentID) ?? 0
                        if documentID > latestDocumentID {
                            latestDocumentID = documentID
                        }
                    }

                    // Create a new document with incremented ID
                    let newDocumentID = latestDocumentID + 1
                    let newDocumentRef = libraryDocumentsRef.document("\(newDocumentID)")

                    // Set the new document data
                    newDocumentRef.setData([
                        "admin_email": adminEmail,
                        "fine_rate": Int(fineRateInput) ?? 0,
                        "library_id": "\(newDocumentID)"
                    ]) { error in
                        if let error = error {
                            print("Error creating new library document: \(error)")
                        } else {
                            print("New library document created with ID: \(newDocumentID)")
                            adminEmail = ""
                            fineRateInput = ""
                            showAlert = true // Show the alert when library is created
                        }
                    }
                }
            }

    
    private func fetchLatestDocumentID(completion: @escaping (Int) -> Void) {
            let db = Firestore.firestore()
            db.collection("librarys").order(by: FieldPath.documentID(), descending: true).limit(to: 1).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching latest document ID: \(error)")
                    completion(0)
                    return
                }

                guard let snapshot = snapshot, let latestDoc = snapshot.documents.first else {
                    print("No latest document found")
                    completion(0)
                    return
                }

                if let latestID = Int(latestDoc.documentID) {
                    completion(latestID)
                } else {
                    print("Invalid document ID format")
                    completion(0)
                }
            }
        }
}
struct CardView<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()

            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
}


struct AdminFunctionsFinal_Previews: PreviewProvider {
    static var previews: some View {
        AdminFunctionsFinal()
    }
}
