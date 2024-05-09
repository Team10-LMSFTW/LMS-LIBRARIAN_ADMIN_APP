import SwiftUI
import Charts
import FirebaseAuth
import Firebase

struct DashboardPage2: View {
    
    @State private var progress: CGFloat = 0.7
    @State private var numberOfUsers: Int = 0
    @State private var penaltyAmount: Int = 0
    @State private var totalQuantityText: Int = 0
    @State private var numberOfRequests: Int = 0
    @State private var membershipTypes: [(type: String, count: Int)] = []
    @State private var isActiveBookFine: Bool = false
    @State private var isActiveMembers: Bool = false
    @State private var TotalBooks: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            
            ZStack {
                Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                            .edgesIgnoringSafeArea(.all)
                
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Dashboard")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                            .padding()
                        
                        HStack(spacing: 40) {
                            Button(action: {
                                self.isActiveBookFine = true
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 250, height: 150)
                                    .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                    .softOuterShadow()
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Book Fines")
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                                .font(.system(size: 20))
                                                
                                            
                                            Text("Rs.\(penaltyAmount)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "5E80D4") : UIColor(hex: "9B98DD")))
                                                .bold()
                                        }
                                            .padding()
                                    )
                            }
                            .fullScreenCover(isPresented: $isActiveBookFine, content: {
                                NavigationView {
                                    LoanView()
                                        .navigationBarItems(leading: Button("Back") {
                                            isActiveBookFine = false
                                        })
                                }
                            })
                            
                            Button(action: {
                                self.isActiveMembers = true
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 250, height: 150)
                                    .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                    .softOuterShadow()
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Members")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                            
                                            Text("\(numberOfUsers)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "5E80D4") : UIColor(hex: "9B98DD")))
                                                .bold()
                                                .onAppear {
                                                    //fetchCategoryOfUsers()
                                                    fetchNumberOfUsers()
                                                    fetchPenaltyAmount()
                                                    fetchRequestCount()
                                                    fetchTotalQuantity()
                                                }
                                        }
                                            .padding()
                                        
                                    )
                            }
                            .fullScreenCover(isPresented: $isActiveMembers, content: {
                                NavigationView {
                                    UserListView3()
                                        .navigationBarItems(leading: Button("Back") {
                                            isActiveMembers = false
                                        })
                                }
                            })
                            
                            
                            
                            Button(action: {
                                self.TotalBooks = true
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 250, height: 150)
                                    .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                    .softOuterShadow()
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Total Books")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                            
                                            Text("\(totalQuantityText)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "5E80D4") : UIColor(hex: "9B98DD")))
                                                .bold()
                                        }
                                            .padding()
                                    )
                            }
                            .fullScreenCover(isPresented: $TotalBooks, content: {
                                NavigationView {
                                    BookTableView()
                                        .navigationBarItems(leading: Button("Back") {
                                            TotalBooks = false
                                        })
                                }
                            })
                            
                            Button(action: {
                                // Action to perform when the button is tapped
                                // You can put your action here
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 250, height: 150)
                                    .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                    .softOuterShadow()
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Requests Raised")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                            
                                            Text("\(numberOfRequests)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "5E80D4") : UIColor(hex: "9B98DD")))
                                                .bold()
                                        }
                                            .padding()
                                    )
                            }
                        }
                        .padding()
                        
                        // Your other content here
                        HStack (spacing: 40) {
                            VStack(alignment: .leading) {
                                Text("Book Ratio")
                                    .font(.system(size: 35, weight: .medium))
                                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                    .padding()
                                
                                Button(action: {
                                    self.TotalBooks = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 370, height: 300)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .overlay(
                                            VStack {
                                                CircularProgress(progress: progress)
                                            }
                                        )
                                }
                                .fullScreenCover(isPresented: $TotalBooks, content: {
                                    NavigationView {
                                        BookTableView()
                                            .navigationBarItems(leading: Button("Back") {
                                                TotalBooks = false
                                            })
                                    }
                                })
                            }
                            
                            
                            VStack(alignment: .leading) {
                                HStack (spacing: 380) {
                                    Text("Top Books")
                                        .font(.system(size: 35, weight: .medium))
                                        .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                        .padding()
                                    
                                    Button(action: {
                                        self.TotalBooks = true
                                    }) {
                                        Text("See all")
                                            .font(.system(size: 30, weight: .medium))
                                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                            .padding()
                                    }
                                    .fullScreenCover(isPresented: $TotalBooks, content: {
                                        NavigationView {
                                            BookTableView()
                                                .navigationBarItems(leading: Button("Back") {
                                                    TotalBooks = false
                                                })
                                        }
                                    })
                                }
                                
                                Button(action: {
                                    self.TotalBooks = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 715, height: 300)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .overlay (
                                            VStack (alignment: .leading) {
                                                HStack {
                                                    HStack (spacing: -55) {
                                                        Text("1")
                                                            .font(
                                                                Font.custom("Inter", size: 180)
                                                                    .weight(.heavy)
                                                            )
                                                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "6E85CE") : UIColor(hex: "9F9FD6")))
                                                        
                                                        VStack {
                                                            Image("book33")
                                                                .resizable()
                                                                .frame(width: 125, height: 180)
                                                                .padding()
                                                                .shadow(color: colorScheme == .light ? Color.black.opacity(0.3) : Color.white.opacity(0.2), radius: 15, x: 10, y: 5)

                                                        }
                                                        
                                                    }
                                                    
                                                    HStack (spacing: -55) {
                                                        Text("2")
                                                            .font(
                                                                Font.custom("Inter", size: 180)
                                                                    .weight(.heavy)
                                                            )
                                                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "6E85CE") : UIColor(hex: "9F9FD6")))
                                                        
                                                        Image("book33")
                                                            .resizable()
                                                            .frame(width: 125, height: 180)
                                                            .padding()
                                                            .shadow(color: colorScheme == .light ? Color.black.opacity(0.3) : Color.white.opacity(0.2), radius: 15, x: 10, y: 5)
                                                    }
                                                    
                                                    HStack (spacing: -55) {
                                                        Text("3")
                                                            .font(
                                                                Font.custom("Inter", size: 180)
                                                                    .weight(.heavy)
                                                            )
                                                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "6E85CE") : UIColor(hex: "9F9FD6")))
                                                        
                                                        Image("book33")
                                                            .resizable()
                                                            .frame(width: 125, height: 180)
                                                            .padding()
                                                            .shadow(color: colorScheme == .light ? Color.black.opacity(0.3) : Color.white.opacity(0.2), radius: 15, x: 10, y: 5)

                                                    }
                                                }
                                                .padding(.leading, -50)
                                                .padding()
                                            }
                                        )
                                }
                                .fullScreenCover(isPresented: $TotalBooks, content: {
                                    NavigationView {
                                        BookTableView()
                                            .navigationBarItems(leading: Button("Back") {
                                                TotalBooks = false
                                            })
                                    }
                                })
                                
                            }
                        }
                        .padding()
                        
                        
                        
                        VStack (alignment: .leading) {
                            Text("Analysis")
                                .font(.system(size: 35, weight: .medium))
                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                .padding()
                            
                            VStack (spacing: 40) {
                                
                                HStack (spacing: 40) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 540, height: 300)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .overlay(
                                            VStack (spacing: 20) {
                                                Text("New Member")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                                
                                                GraphCardView(title: " ", data: sampleData)
                                            }
                                                .padding()
                                        )
                                    
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 540, height: 300)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .overlay(
                                            VStack (spacing: 20) {
                                                Text("New Books")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                                
                                                GraphCardView(title: " ", data: sampleData)
                                            }
                                                .padding()
                                        )
                                    
                                    
                                }
                                
                                HStack (spacing: 40) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 540, height: 300)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .overlay(
                                            VStack (spacing: 20) {
                                                Text("Fines Overdue")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                                
                                                GraphCardView(title: " ", data: sampleData)
                                            }
                                                .padding()
                                        )
                                    
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 540, height: 300)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .overlay(
                                            VStack (spacing: 20) {
                                                Text("Membership Rate")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                                
                                                GraphCardView(title: " ", data: sampleData)
                                            }
                                                .padding()
                                        )
                                }
                            }
                            
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    func fetchNumberOfUsers() {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("category_type", isEqualTo: "Member")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user count: \(error.localizedDescription)")
                    return
                }
                
                if let snapshot = snapshot {
                    self.numberOfUsers = snapshot.documents.count
                }
            }
    }
    
    func fetchCategoryOfUsers() {
        let db = Firestore.firestore()
        
        db.collection("users")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
                
                var membershipTypesSet: Set<String> = Set()
                
                for document in snapshot.documents {
                    if let membershipType = document.data()["membership_type"] as? String {
                        membershipTypesSet.insert(membershipType)
                    }
                }
                
                // Print the unique membership types
                print("Unique Membership Types:")
                for membershipType in membershipTypesSet {
                    print(membershipType)
                    print(membershipType.count)
                }
                
                // Assign the count to numberOfUsers
                
                self.numberOfUsers = membershipTypesSet.count
                
            }
    }
    
    private func fetchTotalQuantity() {
        let db = Firestore.firestore()
        
        db.collection("books")
            .whereField("library_id", isEqualTo: "1")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                var totalQuantity = 0
                var available_quantity = 0
                
                for document in documents {
                    
                    if let total_quantity = document.data()["total_quantity"] as? Int {
                        totalQuantity += total_quantity
                    }
                    if let quantity = document.data()["quantity"] as? Int {
                        available_quantity += quantity
                    }
                }
                
                totalQuantityText = totalQuantity
                progress = CGFloat(available_quantity) / CGFloat(totalQuantity)
                
                
            }
    }
    
    
    private func fetchRequestCount() {
        let db = Firestore.firestore()
        
        db.collection("requests").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            let requestCount = documents.count
            
            // Update the state variable to display the number of requests
            numberOfRequests = requestCount
        }
    }
    
    
    private func fetchPenaltyAmount() {
        let db = Firestore.firestore()
        
        db.collection("loans")
            .whereField("library_id", isEqualTo: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                var totalPenalty: Double = 0
                
                for document in documents {
                    
                    if let penalty = document.data()["penalty_amount"] as? Double {
                        totalPenalty += penalty
                    }
                }
                
                // Convert total penalty amount to an integer
                let totalPenaltyInt = Int(totalPenalty)
                
                // Update the stae variable to display the total penalty amount
                penaltyAmount = (totalPenaltyInt)
            }
    }
    
    
}

#Preview {
    DashboardPage2()
}
