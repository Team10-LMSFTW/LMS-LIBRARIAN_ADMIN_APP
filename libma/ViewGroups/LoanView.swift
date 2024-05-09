import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Define a model for the loan data
struct LoanModel: Identifiable, Codable, Hashable {
    var id: String?
    var bookRefID: String
    var userID: String
    var lendingDate: Timestamp
    var dueDate: Timestamp
    var loanStatus: String
    var penaltyAmount: Int
    var bookName: String
    var isbn: String
    var firstName: String = "Unknown" // Default value for first name
}

// Create a SwiftUI view to display the list of loans in a table format
struct LoanView: View {
    @State private var loans: [LoanModel] = []
    @State private var searchText: String = ""
    @State private var selectedLoanStatus: String = "All Loans"
    private let loanStatusOptions = ["All Loans", "Accepted", "Requested", "Rejected"]
    @State private var showFilterMenu: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                        .edgesIgnoringSafeArea(.all)
            VStack (spacing: 40) {
                Text("Loans List")
                    .font(.title)
                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                    .padding()
                
                HStack (spacing: 40) {
                    TextField("Search Loans...", text: $searchText)
                        .padding(.vertical, 9)
                        .padding(.horizontal)
                        .frame(width: 900)
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

                    
                    Button(action: {
                        showFilterMenu.toggle()
                    }) {
                        Text("Filter")
                            .foregroundColor(colorScheme == .light ? Color(UIColor(hex: "323345")) : Color(UIColor(hex: "F1F2F7")))
                            .frame(width: 120)
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .popover(isPresented: $showFilterMenu) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(loanStatusOptions, id: \.self) { option in
                                Button(action: {
                                    selectedLoanStatus = option
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
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                    .frame(maxWidth: 1120, maxHeight: .infinity)
                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.2), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.2), radius: 10, x: -5, y: -5)
                    .softOuterShadow()
                    .overlay (
                        Table(filteredLoans) {
                            TableColumn("User First Name", value: \.firstName)
                            TableColumn("Book Name", value: \.bookName)
                            TableColumn("Book Ref ID", value: \.bookRefID)
                            TableColumn("Loan Status", value: \.loanStatus)
                            TableColumn("Lending Date") { loan in
                                Text(formattedDate(from: loan.lendingDate))
                            }
                            TableColumn("Due Date") { loan in
                                Text(formattedDate(from: loan.dueDate))
                            }
                            TableColumn("Overdue Days") { loan in
                                let currentDate = Date()
                                if currentDate > loan.dueDate.dateValue() {
                                    let calendar = Calendar.current
                                    let overdueDays = calendar.dateComponents([.day], from: loan.dueDate.dateValue(), to: currentDate).day ?? 0
                                    Text("\(overdueDays)")
                                } else {
                                    Text("0")
                                }
                            }
                            TableColumn("Penalty Amount") { loan in
                                if loan.loanStatus == "accepted" {
                                    let currentDate = Date()
                                    if currentDate > loan.dueDate.dateValue() {
                                        let calendar = Calendar.current
                                        let overdueDays = calendar.dateComponents([.day], from: loan.dueDate.dateValue(), to: currentDate).day ?? 0
                                        let fineRate = 30 // Define your fine rate here
                                        let updatedPenalty = loan.penaltyAmount
                                        Text("\(updatedPenalty)")
                                    } else {
                                        Text("\(loan.penaltyAmount)")
                                    }
                                } else {
                                    Text("N/A")
                                }
                            }
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    )
            }
            .onAppear {
                fetchData()
        }
        }
    }
    
    private var filteredLoans: [LoanModel] {
        let filteredByStatus = selectedLoanStatus == "All Loans" ? loans : loans.filter { $0.loanStatus == selectedLoanStatus.lowercased() }
        
        if searchText.isEmpty {
            return filteredByStatus
        } else {
            return filteredByStatus.filter { loan in
                loan.firstName.lowercased().contains(searchText.lowercased()) ||
                loan.bookName.lowercased().contains(searchText.lowercased()) ||
                loan.bookRefID.lowercased().contains(searchText.lowercased()) ||
                loan.loanStatus.lowercased().contains(searchText.lowercased()) ||
                loan.isbn.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("loans")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                var allLoans: [LoanModel] = []
                
                for document in documents {
                    let data = document.data()
                    
                    guard let bookRefID = data["book_ref_id"] as? String,
                          let lendingDateTimestamp = data["lending_date"] as? Timestamp,
                          let dueDateTimestamp = data["due_date"] as? Timestamp,
                          let loanStatus = data["loan_status"] as? String,
                          let penaltyAmount = data["penalty_amount"] as? Int,
                          let userID = data["user_id"] as? String else {
                        continue
                    }
                    
                    db.collection("books").document(bookRefID).getDocument { bookSnapshot, bookError in
                        if let bookError = bookError {
                            print("Error fetching book document: \(bookError)")
                            return
                        }
                        
                        guard let bookData = bookSnapshot?.data(),
                              let bookName = bookData["book_name"] as? String,
                              let isbn = bookData["isbn"] as? String else {
                            print("Book data not found.")
                            return
                        }
                        
                        db.collection("users").document(userID).getDocument { userSnapshot, userError in
                            if let userError = userError {
                                print("Error fetching user document: \(userError)")
                                return
                            }
                            
                            var firstName = "Unknown"
                            if let userData = userSnapshot?.data(),
                               let userFirstName = userData["first_name"] as? String {
                                firstName = userFirstName
                            }
                            
                            let loan = LoanModel(id: document.documentID,
                                                 bookRefID: bookRefID,
                                                 userID: userID,
                                                 lendingDate: lendingDateTimestamp,
                                                 dueDate: dueDateTimestamp,
                                                 loanStatus: loanStatus,
                                                 penaltyAmount: penaltyAmount,
                                                 bookName: bookName,
                                                 isbn: isbn,
                                                 firstName: firstName)
                            
                            allLoans.append(loan)
                            
                            // Update the @State variable to trigger UI refresh
                            self.loans = allLoans
                        }
                    }
                }
            }
    }
    
    private func formattedDate(from timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy" // Format: Day Month Year (e.g., 01 Jan 2022)
        return dateFormatter.string(from: timestamp.dateValue())
    }
}

// Preview for SwiftUI Canvas
struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        LoanView()
    }
}
