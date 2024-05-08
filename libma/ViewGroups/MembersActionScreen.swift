import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Step 1: Define a model for the user data
struct UserData2: Identifiable, Codable {
    @DocumentID var id: String?
        var categoryType: String?
        var email: String?
        var firstName: String?
        var lastName: String?
        var libraryID: String?
        var membershipType: String?
        var rating: Int?

        // Computed properties to return non-optional values
        var nonOptionalCategoryType: String {
            return categoryType ?? "N/A"
        }

        var nonOptionalEmail: String {
            return email ?? "N/A"
        }

        var nonOptionalLibraryID: String {
            return libraryID ?? "N/A"
        }

        var nonOptionalMembershipType: String {
            return membershipType ?? "N/A"
        }
    }

struct SubCard: View {
    var title: String
    var value: Int
    var total: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.top)
            
            ProgressView(value: Double(value), total: Double(total))
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
        }
        .padding()
        .background(Color(red: 0.94, green: 0.92, blue: 1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

// Step 2: Create a SwiftUI view to display the list of users
struct UserListView3: View {
    @State private var users: [UserData2] = []
    @State private var searchText: String = ""
    @State private var filterOptions: [String] = ["All Users", "Member", "Librarian", "Admin"]
    @State private var selectedFilter: String = "All Users"
    @State private var showFilterMenu: Bool = false

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
            Color(hex: 0xEEEEEE)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Members List")
                    .font(.title)
                    .padding()

                HStack {
                    TextField("Search Users...", text: $searchText)
                        .padding(.vertical, 9) // Adjust vertical padding to reduce the size
                        .padding(.horizontal) // Maintain horizontal padding
                        .background(Color.white)  // Add white background
                        .cornerRadius(8) // Add corner radius for a rounded look
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
                            .padding(.vertical, 4) // Adjust vertical padding to match the search bar
                            .padding(.horizontal) // Maintain horizontal padding
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
                .padding() // Add padding around the HStack


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
        }
        .onAppear {
            fetchData()
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
}

// Custom Card view
struct Card1<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(.white)
            .cornerRadius(8)
    }
}

struct UserListView3_Previews: PreviewProvider {
    static var previews: some View {
        UserListView3()
    }
}

// Extension for UIColor from hex value
//extension Color {
//    init(hex: UInt, alpha: Double = 1) {
//        self.init(
//            .sRGB,
//            red: Double((hex >> 16) & 0xFF) / 255.0,
//            green: Double((hex >> 8) & 0xFF) / 255.0,
//            blue: Double(hex & 0xFF) / 255.0,
//            opacity: alpha
//        )
//    }
//}
