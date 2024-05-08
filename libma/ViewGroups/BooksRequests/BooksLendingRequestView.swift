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
    @State private var selectedStatus = "All"
       
    let statuses = ["All", "accepted", "rejected", "active"]
    var body: some View {
        VStack {
            Text("Lending Requests")
                .font(.largeTitle)
            Picker("Status", selection: $selectedStatus) {
                           ForEach(statuses, id: \.self) {
                               Text($0)
                           }
                       }
                       .pickerStyle(SegmentedPickerStyle())
                       .padding()
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(requests.filter { $0.loan_status == selectedStatus || selectedStatus == "All" }) { request in
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color(red: 0.94, green: 0.92, blue: 1)) // Set the background color
                                                             .frame(maxWidth: .infinity)
                                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                                            .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5)

                            BookLendingRequestCardView(request: request)
                        }
                        
                    }
                }
                .padding()
            }
            .navigationTitle("Book Requests")
            Spacer()
        }
        .onAppear {
            fetchData()
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
    
    let request: Loan
    
    
    var body: some View {
        HStack(spacing: 20) {
            if let book = bookViewModel.book {
                VStack(alignment: .leading, spacing: 0){
                    Text(book.book_name)
                        .font(.title)
                        .foregroundColor(Color(.black))
                    
                    HStack(spacing: 5) {
                        AsyncImage(url: URL(string: book.cover_url)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 250) // Increased image size
                                    .cornerRadius(8)
                            case .failure(_):
                                Image(systemName: "book")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView()
                                    .frame(width: 120, height: 120)
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
                            Spacer()
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            VStack(alignment: .leading, spacing: 5){
                if let book = bookViewModel.book {
                    Text("Lending Date: \(lendingDate)")
                        .font(.subheadline)
                    Text("Return Date: \(returnDate)")
                        .font(.subheadline)
                        .padding(.vertical, 30)
                }
                
                HStack{
                    
                    Button(action: {
                        updateLoanStatus(status: "accepted")
                    }) {
                        Text("Accept")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        updateLoanStatus(status: "rejected")
                    }) {
                        Text("Reject")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(Color.red)
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
                .background(Color(red: 0.94, green: 0.92, blue: 1))
                .cornerRadius(20)
                .shadow(color: Color("Shadow"), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white, radius: 10, x: -5, y: -5)

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



//class BookViewModel: ObservableObject {
//    @Published var book: Book?
//    
//    func fetchBook(for bookRefID: String) {
//        let db = Firestore.firestore()
//        db.collection("books").document(bookRefID)
//            .getDocument { document, error in
//                if let error = error {
//                    print("Error fetching book: \(error)")
//                    return
//                }
//                
//                if let document = document, document.exists {
//                    do {
//                        let book = try document.data(as: Book.self)
//                        DispatchQueue.main.async {
//                            self.book = book
//                        }
//                    } catch {
//                        print("Error decoding book: \(error)")
//                    }
//                } else {
//                    print("Book does not exist")
//                }
//            }
//    }
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
                
                guard let document = document, document.exists else {
                    print("Book does not exist")
                    return // Exit if book does not exist
                }
                
                do {
                    let book = try document.data(as: Book.self)
                    DispatchQueue.main.async {
                        self.book = book
                    }
                } catch {
                    print("Error decoding book: \(error)")
                }
            }
    }
}

//}
#Preview {
    BooksLendingRequestView()
}
