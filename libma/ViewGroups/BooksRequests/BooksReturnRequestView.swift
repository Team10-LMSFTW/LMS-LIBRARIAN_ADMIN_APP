import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

struct BooksReturnRequestView: View {
    @State var requests: [Loan] = []
    
    var body: some View {
        VStack {
            Text("Return Requests")
                .font(.largeTitle)
                
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(requests) { request in
                        BookLendingRequestCardView(request: request)
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
            .whereField("loan_status", isEqualTo: "accepted")
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

struct BooksReturnRequestCardView: View {
    @StateObject var bookModel = BookViewModel()
    let request: Loan
    
    var body: some View {
        VStack(alignment: .leading) {
            if let book = bookModel.book {
                HStack {
                    VStack(alignment: .leading){
                        Text(book.book_name)
                            .font(.largeTitle)
                        
                        HStack(spacing: 5) {
                            AsyncImage(url: URL(string: book.cover_url)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(8)
                                case .failure(_):
                                    Image(systemName: "book")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
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
                                Text("Lending Date: \(request.lending_date)")
                                Text("Return Date: \(request.due_date)")
                                Spacer()
                                
                                
                            }
                            .padding()
                            VStack(alignment: .leading, spacing: 5){
                                Text("Requested by: \(request.user_id)")
                                Text("User ID: \(request.user_id)")
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        updateLoanStatus(status: "returned")
                                    }) {
                                        Text("Return")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color.green)
                                            .cornerRadius(8)
                                    }
                                    
                                }
                            }.padding()
                            
                        }
                        
                    }
                }.padding()
            }
        }
        .onAppear {
            bookModel.fetchBook(for: request.book_ref_id)
        }
        .padding()
        .background(Color(red: 0.94, green: 0.92, blue: 1))
        .cornerRadius(12)
        .shadow(radius: 0).frame(height: 300)
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
}

class BookVModel: ObservableObject {
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
