import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

struct BooksReturnRequestView: View {
    @State var requests: [Loan] = []
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                        .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Return Requests")
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                    .padding()
                
                ScrollView {
                    VStack(spacing: 40) {
                        ForEach(requests) { request in
                            ZStack {
                                HStack (alignment: .center) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 1120)
                                        .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                        .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                        .softOuterShadow()
                                }
                                BooksReturnRequestCardView(request: request)
                                    .padding()
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
    
    @Environment(\.colorScheme) var colorScheme
    
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
                            Text("Requested by: \(request.user_id)")
                                .padding()
                        }
                        .padding(.leading)
                    }
                    .padding(.trailing, 120)
                }
            }
            VStack(alignment: .leading, spacing: 5){
                if let book = bookModel.book {
                    
                  
                    VStack {
                        Text("Lending Date: \(dateFormatter.string(from: request.lending_date.dateValue()))")
                            .font(.subheadline)
                        
                        
                        Text("Return Date: \(dateFormatter.string(from: request.due_date.dateValue()))")
                            .font(.subheadline)
                            .padding(.vertical, 30)
                    }
                }
                    
                
                HStack(spacing: 20) {
                    
                    Button(action: {
                        updateLoanStatus(status: "returned")
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
                        Text("Remark")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                            .background(colorScheme == .light ? Color(UIColor(hex: "DF8CB2")) : Color(UIColor(hex: "DE7288")))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
        }

        .onAppear {
            bookModel.fetchBook(for: request.book_ref_id)
        }
        .padding(10)
        .background(Color("CardBackground"))
        .cornerRadius(20)
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

struct BooksReturnRequestView_Previews: PreviewProvider {
    static var previews: some View {
        BooksReturnRequestView()
    }
}
