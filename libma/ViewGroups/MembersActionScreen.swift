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
    @State private var premiumSubscribers: Int = 50
        @State private var basicSubscribers: Int = 100
        @State private var freeSubscribers: Int = 200
        
        var totalSubscribers: Int {
            premiumSubscribers + basicSubscribers + freeSubscribers
        }
        
        var body: some View {
            ZStack {
                Color(hex: 0xEEEEEE)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Card1 {
                        VStack {
                            Text("Users Membership Distribution")
                                .font(.title)
                                .padding()
                            
                            HStack {
                                // Premium Subscribers Card
                                SubCard(title: "Premium Subscribers", value: premiumSubscribers, total: totalSubscribers)
                                
                                // Basic Subscribers Card
                                SubCard(title: "Basic Subscribers", value: basicSubscribers, total: totalSubscribers)
                                
                                // Free Subscribers Card
                                SubCard(title: "Free Subscribers", value: freeSubscribers, total: totalSubscribers)
                            }
                        }
                    }
                    
                Card1 {
                    VStack(alignment:.center) {
                        Text("Members List")
                            .font(.title)
                            .padding()
                        
                        // Table headers
                        HStack (spacing: 130) {
                            Text("Name")
                                .padding()
                            Text("Category")
                                .padding()
                            Text("Email")
                                .padding()
                            Text("Library ID")
                                .padding()
                            Text("Membership Type")
                                .padding()
                            Text("Rating")
                                .padding()
                        }
                        
                        List(users) { user in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(user.firstName ?? "N/A") \(user.lastName ?? "N/A")")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                
                                Text(user.categoryType ?? "N/A")
                                    .frame(maxWidth: .infinity, alignment: .center)

                                
                                Text(user.email ?? "N/A")
                                    .frame(maxWidth: .infinity, alignment: .center)

                                
                                Text(user.libraryID ?? "N/A")
                                    .frame(maxWidth: .infinity, alignment: .center)

                                
                                Text(user.membershipType ?? "N/A")
                                    .frame(maxWidth: .infinity, alignment: .center)

                                
                                Text(user.rating.map { "\($0)" } ?? "N/A")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal)

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 0.94, green: 0.92, blue: 1))
                        .padding()
                        
                    }
                }

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
            .whereField("category_type", isEqualTo: "Member")
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
