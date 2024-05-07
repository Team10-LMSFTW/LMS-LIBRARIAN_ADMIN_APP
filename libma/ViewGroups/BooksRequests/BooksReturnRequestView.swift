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
                .padding(.top, 50)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(requests) { request in
                        ZStack(alignment: .topLeading) { // Use ZStack for layering
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.94, green: 0.92, blue: 1)) // Set the background color
                                .frame(maxWidth: .infinity)
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5)
                            
                            BooksReturnRequestCardView(request: request) // Overlay content on top
                                .padding()
                        }
                        .padding()
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("Book Requests")
            Spacer()
        }
        .onAppear {
            fetchData()
        }
        .background(Color.white.ignoresSafeArea()) // Change main background color to white
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
    @StateObject var bookModel = BookVModel()
    let request: Loan
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 20) {
            if let book = bookModel.book {
                VStack(alignment: .leading){
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
                            Text("Requested by: \(request.user_id)")
                                .padding()
                            Spacer()
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            VStack(alignment: .leading, spacing: 5){
                if let book = bookModel.book {
                    
                  
                    Text("Lending Date: \(dateFormatter.string(from: request.lending_date.dateValue()))")
                        .font(.subheadline)
                    
                    Text("Return Date: \(dateFormatter.string(from: request.due_date.dateValue()))")
                        .font(.subheadline)
                        .padding(.vertical, 30)
                }
                    
                
                HStack{
                    
                    Button(action: {
                        updateLoanStatus(status: "returned")
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
                        Text("Remark")
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
            bookModel.fetchBook(for: request.book_ref_id)
        }
        .padding(10)
        .background(Color("CardBackground"))
        .cornerRadius(20)
        .shadow(color: Color("Shadow"), radius: 10, x: 5, y: 5)
        .shadow(color: Color.white, radius: 10, x: -5, y: -5)
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

#if DEBUG
struct BooksReturnRequestView_Previews: PreviewProvider {
    static var previews: some View {
        BooksReturnRequestView()
    }
}
#endif

