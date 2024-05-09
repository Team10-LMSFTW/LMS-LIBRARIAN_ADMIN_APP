import SwiftUI
import Firebase

struct AdminFunctionsFinal: View {
    @State private var users: [UserData2] = []
    @State private var searchText: String = ""
    @State private var filterOptions: [String] = ["All Users", "Member", "Librarian", "Admin"]
    @State private var selectedFilter: String = "All Users"
    @State private var showFilterMenu: Bool = false
    @State private var selectedLibrary: String = ""
    @State private var fineAmount: String = ""
    @State private var libraryID: String = ""
    @State private var libraries: [String] = []
    @State private var fineRate: Int = 0
    @State private var showAlert: Bool = false
    @State private var adminEmail: String = ""
    @State private var fineRateInput: String = ""
    @State private var isCreateUserPagePresented = false
    
    @Environment(\.colorScheme) var colorScheme

    var filteredUsers: [UserData2] {
        let searchedUsers = searchText.isEmpty ? users : users.filter { user in
            let searchTermLower = searchText.lowercased()
            return user.firstName?.lowercased().contains(searchTermLower) ?? false ||
                user.lastName?.lowercased().contains(searchTermLower) ?? false ||
                user.categoryType?.lowercased().contains(searchTermLower) ?? false ||
                user.email?.lowercased().contains(searchTermLower) ?? false ||
                user.libraryID?.lowercased().contains(searchTermLower) ?? false ||
                user.membershipType?.lowercased().contains(searchTermLower) ?? false ||
                (user.rating?.description.lowercased().contains(searchTermLower) ?? false)
        }

        if selectedFilter == "All Users" {
            return searchedUsers
        } else {
            return searchedUsers.filter { $0.categoryType == selectedFilter }
        }
    }

    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                        .edgesIgnoringSafeArea(.all)
            VStack {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                    .frame(width: 1120, height: 550)
                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.2), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.black.opacity(0.1), radius: 10, x: -5, y: -5)
                    .softOuterShadow()
                    .overlay (
                        VStack(alignment: .center) {
                            HStack {  // work here for plus button
                                Text("User List")
                                    .font(Font.custom("SF Pro", size: 30).weight(.semibold))
                                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                    .padding()
                            }
                            
                            HStack {
                                TextField("Search Users...", text: $searchText)
                                    .padding(.vertical, 9)
                                    .padding(.horizontal)
                                    .background(Color(colorScheme == .light ? UIColor(hex: "DCDFE6") : UIColor(hex: "3B3D60")))
                                    .cornerRadius(8)
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
                                    )
                                
                                Spacer()
                                
                                Button(action: {
                                    showFilterMenu.toggle()
                                }) {
                                    Text("Filter")
                                        .foregroundColor(colorScheme == .light ? Color(UIColor(hex: "323345")) : Color(UIColor(hex: "F1F2F7")))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(BorderedButtonStyle())
                                .popover(isPresented: $showFilterMenu) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        ForEach(filterOptions, id: \.self) { option in
                                            Button(action: {
                                                selectedFilter = option
                                                showFilterMenu = false
                                            }) {
                                                Text(option)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .padding()
                            
                            Table(filteredUsers) {
                                TableColumn("Name") { user in
                                    Text("\(user.firstName ?? "N/A") \(user.lastName ?? "N/A")")
                                }
                                TableColumn("Category", value: \.nonOptionalCategoryType)
                                TableColumn("Email", value: \.nonOptionalEmail)
                                TableColumn("Library ID", value: \.nonOptionalLibraryID)
                                TableColumn("Membership Type", value: \.nonOptionalMembershipType)
                                TableColumn("Rating") { user in
                                    Text(user.rating.map { "\($0)" } ?? "N/A")
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(red: 0.94, green: 0.92, blue: 1))
                            .padding()
                        }
                    )

                HStack (spacing: 40) {
            
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                        .frame(width: 520, height: 340)
                        .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.2), radius: 10, x: 5, y: 5)
                        .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.black.opacity(0.1), radius: 10, x: -5, y: -5)
                        .softOuterShadow()
                        .overlay(
                            VStack {
                                Text("Fine Rates")
                                .font(Font.custom("SF Pro", size: 30).weight(.semibold))
                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                .padding()
                                
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
                                        .padding(.vertical, 9)
                                        .padding(.horizontal)
                                        .background(Color(colorScheme == .light ? UIColor(hex: "DCDFE6") : UIColor(hex: "3B3D60")))
                                        .cornerRadius(8)
                                        .keyboardType(.numberPad)
                                        .padding()
                                    
                                    // Button to Update Fine Rate
                                    Button(action: {
                                        updateFineRate()
                                        showAlert = true // Show the alert when fine rate is updated
                                    }) {
                                        Text("Update Fine Rate")
                                            .foregroundColor(colorScheme == .light ? Color.white : Color.black).opacity(0.9)
                                            .padding()
                                            .background(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "7B7ED3")))
                                            .cornerRadius(10)
                                            .frame(width: 250)
                                    }
                                    .padding()
                                }
                                    .padding()
                                    .frame(width: 500, height: 250)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                            .softOuterShadow()
                                )
                            }
                        )
                    
                    // Card 3: Create Library
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                        .frame(width: 520, height: 340)
                        .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.2), radius: 10, x: 5, y: 5)
                        .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.black.opacity(0.1), radius: 10, x: -5, y: -5)
                        .softOuterShadow()
                        .overlay (
                            VStack {
                                Text("Create Libraray")
                                .font(Font.custom("SF Pro", size: 30).weight(.semibold))
                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                .padding()
                                
                                VStack {
                                    // Text Field for Admin Email
                                    TextField("Admin Email", text: $adminEmail)
                                        .padding(.vertical, 9)
                                        .padding(.horizontal)
                                        .background(Color(colorScheme == .light ? UIColor(hex: "DCDFE6") : UIColor(hex: "3B3D60")))
                                        .cornerRadius(8)
                                        .keyboardType(.numberPad)
                                        .padding()
                                    
                                    // Text Field for Fine Rate
                                    TextField("Fine Rate", text: $fineRateInput)
                                        .padding(.vertical, 9)
                                        .padding(.horizontal)
                                        .background(Color(colorScheme == .light ? UIColor(hex: "DCDFE6") : UIColor(hex: "3B3D60")))
                                        .cornerRadius(8)
                                        .keyboardType(.numberPad)
                                        .padding()
                                    
                                    // Button to Create Library
                                    Button(action: {
                                        createLibrary()
                                    }) {
                                        Text("Create Your Library")
                                            .foregroundColor(colorScheme == .light ? Color.white : Color.black).opacity(0.9)
                                            .padding()
                                            .background(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "7B7ED3")))
                                            .cornerRadius(10)
                                            .frame(width: 250)
                                    }
                                    .padding()
                                    .alert(isPresented: $showAlert) {
                                        Alert(title: Text("Congratulations!"), message: Text("Your new Library is created"), dismissButton: .default(Text("OK")))
                                    }
                                }
                                .padding()
                                .frame(width: 500, height: 250)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .softOuterShadow()
                                    )
                            }
                    )
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
