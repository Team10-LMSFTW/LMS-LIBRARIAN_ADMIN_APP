import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift



struct BooksRenewalsRequestView: View {
    @State var requests: [Loan] = []
    let books: Book
//    let request: Loan
    
    var body: some View {
        
        VStack {
            Text("Renew Requests")
                .font(.largeTitle)
                
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(requests) { request in
                        BookRenewalsRequestCardView(book: books, request: request)
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
                          let user_id = data["user_id"] as? String,
                          let penaltyAmt  = data["penalty_amount"] as? Int,
                          let libID  = data["library_id"] as? Int
                    else {
                        continue
                    }
                    
                    let loan = Loan(id: document.documentID, book_ref_id: bookRefID, lending_date: lendingDateTimestamp, due_date: dueDateStamp, user_id: user_id, penalty_amount: penaltyAmt, library_id: libID, loan_status: "accepted")
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

struct BookRenewalsRequestCardView: View {
    let book: Book
    @State var request: Loan
    @State var extended: Bool = false
    @StateObject var bookViewModel = BookViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading){
                    Text(book.book_name)
                        .font(.largeTitle)
                        .padding()
                    HStack(spacing: 50) {
                        AsyncImage(url: URL(string: book.cover_url)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            case .failure(_):
                                Image(systemName: "book")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 150)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 150)
                            @unknown default:
                                EmptyView()
                            }
                        }.padding()
                        VStack(alignment: .leading,spacing: 30) {
                            
                            Text("ISBN: \(book.isbn)")
                            
                            Text("Lending Date: \(request.lending_date)")
                            Spacer()
                            
                        }
                        .padding()
                        VStack(alignment: .leading, spacing: 20){
                            Text("Requested by: \(request.user_id)")
                            Text("User ID: \(request.user_id)")
                            
                            Text("Return Date: \(request.due_date)")
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    extendReturnDate()
                                }) {
                                    Text("Extend")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.green)
                                        .cornerRadius(8)
                                }
//                                Button(action: {
//                                    // Action for rejecting request
//                                }) {
//                                    Text("Reject")
//                                        .padding()
//                                        .foregroundColor(.white)
//                                        .background(Color.red)
//                                        .cornerRadius(8)
//                                }
                            }
                        }//.padding()
                        
                    }
                    
                }
            }
            
        }
        .onAppear {
            bookViewModel.fetchBook(for: request.book_ref_id)
        }
        .padding()
        .background(Color(Color(red: 0.94, green: 0.92, blue: 1)))
        .cornerRadius(12)
        .shadow(radius: 0)
        
    }
    
    private func extendReturnDate() {
        // Get current due date
        guard var dueDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: request.due_date.dateValue()) else {
            return
        }
       
        request.due_date = Timestamp(date: dueDate)
        
        let db = Firestore.firestore()
        db.collection("loans").document(request.id ?? "").setData(["due_date": request.due_date], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
