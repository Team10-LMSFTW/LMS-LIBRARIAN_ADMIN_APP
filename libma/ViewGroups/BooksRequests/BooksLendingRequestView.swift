import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
import Neumorphic

struct Loan: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var book_ref_id: String
    var lending_date: Timestamp
    var due_date : Timestamp

    var user_id : String
    var penalty_amount: Int
    var library_id : Int

    var loan_status: String // Added property for loan_status
}

struct BooksLendingRequestView: View {
    @State var requests: [Loan] = []
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                        .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Lending Requests")
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                    .padding()
                    .padding(.bottom, 10)
                    
                ScrollView {
                    VStack(spacing: 40) {
                        ForEach(requests) { request in
                            ZStack() {
                                HStack (alignment: .center) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 1120)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                        .padding(.top, -10)
                                        .padding(.bottom, -10)
                                }
                                BookLendingRequestCardView(request: request)
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Book Requests")
            }
            .onAppear {
                fetchData()
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
                
                var allLoans: [Loan] = []
                
                for document in documents {
                    let data = document.data()
                    print(data)
                    guard let bookRefID = data["book_ref_id"] as? String,
                          let lendingDateTimestamp = data["lending_date"] as? Timestamp,
                          let dueDateStamp = data["due_date"] as? Timestamp,
                          let loanStatus = data["loan_status"] as? String,
                          let user_id = data["user_id"] as? String,
                          let penaltyAmt  = data["penalty_amount"] as? Int,
                          let libID  = data["library_id"] as? Int
                    else {
                        continue
                    }
                    
                    let loan = Loan(id: document.documentID, book_ref_id: bookRefID, lending_date: lendingDateTimestamp, due_date: dueDateStamp, user_id: user_id, penalty_amount: penaltyAmt, library_id: libID, loan_status: loanStatus)
                    print(loan)
                    allLoans.append(loan)
                    print("all loans hai")
                    print(allLoans)
                }
                
                allLoans.sort(by: { $0.lending_date.dateValue() > $1.lending_date.dateValue() })
                self.requests = allLoans
            }
    }
}

struct BookLendingRequestCardView: View {
    @StateObject var bookViewModel = BookViewModel()
    @State private var userName = ""
    @State private var lendingDate = ""
    @State private var returnDate = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    let request: Loan
    
    
    var body: some View {
        HStack(spacing: 20) {
            if let book = bookViewModel.book {
                VStack(alignment: .leading, spacing: 0){
                    Text(book.book_name)
                        .font(.title)
                        .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        .padding(.leading, 30)
                    
                    HStack(spacing: 5) {
                        AsyncImage(url: URL(string: book.cover_url)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 250)
                                    .cornerRadius(10)
                            case .failure(_):
                                Image(systemName: "book")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                                    .cornerRadius(10)
                            case .empty:
                                ProgressView()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                            @unknown default:
                                EmptyView()
                            }
                        }.padding()

                        VStack(alignment: .leading,spacing: 5) {
                            Text("ISBN: \(book.isbn)")
                                .padding()
                            Text("User ID: \(request.user_id)")
                                .padding()
                            Text("Requested by: \(userName)")
                                .padding()
                        }
                        .padding(.leading)
                    }
                    .padding(.trailing, 120)
                }
            }
            VStack(alignment: .leading, spacing: 5){
                if let book = bookViewModel.book {
                    
                    VStack {
                        Text("Lending Date: \(lendingDate)")
                            .font(.subheadline)
                        
                        Text("Return Date: \(returnDate)")
                            .font(.subheadline)
                            .padding(.vertical, 30)
                    }
                }
                
                HStack (spacing: 20) {
                    
                    Button(action: {
                        updateLoanStatus(status: "accepted")
                    }) {
                        Text("Accept")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(colorScheme == .light ? Color(UIColor(hex: "7A9BDD")) : Color(UIColor(hex: "8D89DA")))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        updateLoanStatus(status: "rejected")
                    }) {
                        Text("Reject")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(colorScheme == .light ? Color(UIColor(hex: "DF8CB2")) : Color(UIColor(hex: "DE7288")))
                            .cornerRadius(8)
                    }
                }
            }.padding()
            
        }

        .onAppear {
            bookViewModel.fetchBook(for: request.book_ref_id)
            fetchUserName()
            formatDates()
        }
        .padding(10)
        .background(Color("CardBackground"))
        .cornerRadius(20)
        
    }
    
    private func fetchUserName() {
        let db = Firestore.firestore()
        db.collection("users").document(request.user_id)
            .getDocument { document, error in
                if let error = error {
                    print("Error fetching user: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    guard let firstName = document["first_name"] as? String,
                          let lastName = document["last_name"] as? String else { return }
                    userName = "\(firstName) \(lastName)"
                } else {
                    print("User does not exist")
                }
            }
    }
    
    private func updateLoanStatus(status: String) {
        let db = Firestore.firestore()
        db.collection("loans").document(request.id ?? "")
            .updateData(["loan_status": status]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
    }
    
    private func formatDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        lendingDate = dateFormatter.string(from: request.lending_date.dateValue())
        returnDate = dateFormatter.string(from: request.due_date.dateValue())
    }
}



class BookViewModel: ObservableObject {
    @Published var book: Book?
    
    func fetchBook(for bookRefID: String) {
        let db = Firestore.firestore()
        db.collection("books").document(bookRefID)
            .getDocument { document, error in
                if let error = error {
                    print("Error fetching book: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    do {
                        let book = try document.data(as: Book.self)
                        DispatchQueue.main.async {
                            self.book = book
                        }
                    } catch {
                        print("Error decoding book: \(error)")
                    }
                } else {
                    print("Book does not exist")
                }
            }
    }
}
#Preview {
    BooksLendingRequestView()
}
