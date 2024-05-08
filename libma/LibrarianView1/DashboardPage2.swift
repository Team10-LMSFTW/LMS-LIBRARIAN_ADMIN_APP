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
   
    var body: some View {
        HStack {
           
            ZStack {
                Color(hex: 0xFFFFFF)
                    .edgesIgnoringSafeArea(.all)
               
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Dashboard")
                            .font(
                                Font.custom("SF Pro", size: 35)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding()
                       
                        HStack(spacing: 35) {
                            Button(action: {
                                self.isActiveBookFine = true
                            }) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 249, height: 148)
                                    .background(Color(red: 0.94, green: 0.92, blue: 1))
                                    .cornerRadius(20)
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Fines Collected")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                           
                                            Text("Rs. \(penaltyAmount)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
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
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 249, height: 148)
                                    .background(Color(red: 0.94, green: 0.92, blue: 1))
                                    .cornerRadius(20)
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("User Info")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                           
                                            Text("\(numberOfUsers)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                                                .bold()
                                                .onAppear {
                                        //            fetchCategoryOfUsers()
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
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 249, height: 148)
                                    .background(Color(red: 0.94, green: 0.92, blue: 1))
                                    .cornerRadius(20)
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Books List")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                           
                                            Text("\(totalQuantityText)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
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
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 249, height: 148)
                                    .background(Color(red: 0.94, green: 0.92, blue: 1))
                                    .cornerRadius(20)
                                    .overlay(
                                        VStack (spacing: 20) {
                                            Text("Requests Raised")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                           
                                            Text("\(numberOfRequests)")
                                                .font(.system(size: 50))
                                                .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                                                .bold()
                                        }
                                            .padding()
                                    )
                            }
                           
                           
                            Spacer()
                            Spacer()
                        }
                        .padding()
                       
                        // Your other content here
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Active Book List")
                                    .font(
                                        Font.custom("SF Pro", size: 35)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                                    .padding()
                               
                                Button(action: {
                                    self.TotalBooks = true
                                }) {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(red: 0.94, green: 0.92, blue: 1))
                                        .cornerRadius(20)
                                        .frame(width: 381, height: 317)
                                        .padding(.leading)
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

                           
                            Spacer()
                           
                            VStack(alignment: .leading) {
                                HStack (spacing: 350) {
                                    Text("Top Books")
                                        .font(
                                            Font.custom("SF Pro", size: 35)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.black)
                                        .padding()
                                   
                                    Button(action: {
                                        self.TotalBooks = true
                                    }) {
                                        Text("See all")
                                            .font(
                                                Font.custom("SF Pro", size: 28)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(.black)
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
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(red: 0.94, green: 0.92, blue: 1))
                                        .cornerRadius(20)
                                        .frame(width: 650, height: 317)
                                        .padding(.leading)
                                        .padding(.trailing, 80)
                                        .overlay (
                                            VStack (alignment: .leading) {
                                                HStack {
                                                    HStack (spacing: -45) {
                                                        Text("1")
                                                            .font(
                                                                Font.custom("Inter", size: 140)
                                                                    .weight(.heavy)
                                                            )
                                                            .foregroundColor(.black)

                                                        VStack {
                                                            Image("book11")
                                                                .resizable()
                                                                .frame(width: 122, height: 179)
                                                                .padding()
                                                        }

                                                    }

                                                    HStack (spacing: -45) {
                                                        Text("2")
                                                            .font(
                                                                Font.custom("Inter", size: 140)
                                                                    .weight(.heavy)
                                                            )
                                                            .foregroundColor(.black)

                                                        Image("book22")
                                                            .resizable()
                                                            .frame(width: 113, height: 155)
                                                            .padding()
                                                    }

                                                    HStack (spacing: -45) {
                                                        Text("3")
                                                            .font(
                                                                Font.custom("Inter", size: 140)
                                                                    .weight(.heavy)
                                                            )
                                                            .foregroundColor(.black)

                                                        Image("book33")
                                                            .resizable()
                                                            .frame(width: 122, height: 169)
                                                            .padding()
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
                       
                        VStack(alignment: .leading) {
                            Text("Analysis")
                                .font(
                                    Font.custom("SF Pro", size: 35)
                                        .weight(.bold)
                                )
                                .foregroundColor(.black)
                                .padding(.leading, 35)
                           
                            VStack {
                                HStack {
                                    HStack {
                                       
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 542, height: 317)
                                            .background(Color(red: 0.94, green: 0.92, blue: 1))
                                            .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("New Member")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                   
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                    .padding()
                                            )
                                       
                                    }
                                    .padding()
                                   
                                    HStack {
                                       
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 542, height: 317)
                                            .background(Color(red: 0.94, green: 0.92, blue: 1))
                                            .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("New Books")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                   
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                    .padding()
                                            )
                                       
                                    }
                                    .padding()
                                   
                                   
                                }
                                .padding()
                               
                                HStack {
                                    HStack {
                                       
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 542, height: 317)
                                            .background(Color(red: 0.94, green: 0.92, blue: 1))
                                            .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("Fines Overdue")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                   
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                    .padding()
                                            )
                                       
                                    }
                                    .padding()
                                   
                                    HStack {
                                       
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 542, height: 317)
                                            .background(Color(red: 0.94, green: 0.92, blue: 1))
                                            .cornerRadius(20)
                                            .overlay(
                                                VStack (spacing: 20) {
                                                    Text("Membership Rate")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                   
                                                    GraphCardView(title: " ", data: sampleData)
                                                }
                                                    .padding()
                                            )
                                       
                                    }
                                    .padding()
                                   
                                   
                                }
                                .padding()
                               
                            }
                           
                           
                        }
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
