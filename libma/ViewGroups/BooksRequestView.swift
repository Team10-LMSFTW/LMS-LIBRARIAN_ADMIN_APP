//
//  BooksRequestView.swift
//  libma
//
//  Created by admin on 02/05/24.
//

import SwiftUI

struct BooksRequest: Identifiable {
    let id: UUID
    var bookISBN: String
    var requesterName: String
    var requesterID: String
    var lendingDate: String
    var returnDate: String
    
    init(id: UUID = UUID(), bookISBN: String, requesterName: String, requesterID: String, lendingDate: String, returnDate: String) {
        self.id = id
        self.bookISBN = bookISBN
        self.requesterName = requesterName
        self.requesterID = requesterID
        self.lendingDate = lendingDate
        self.returnDate = returnDate
    }
}

struct BooksRequestView: View {
    let requests: [BooksRequest]
    let books: [Book]
    
    var body: some View {
        
        VStack {
            Text("Requests")
                .font(.largeTitle)
                
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(requests) { request in
                        if let book = books.first(where: { $0.isbn == request.bookISBN }) {
                            BookRequestCardView(book: book, request: request)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Book Requests")
            Spacer()
        }
    }
}

struct BookRequestCardView: View {
    let book: Book
    let request: BooksRequest
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading){
                    Text(book.book_name)
                        .font(.largeTitle)
                        .padding()
                    HStack(spacing: 150) {
                        // Book cover image

                            HStack (spacing: 50) {
                                
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
                                    Text("Lending Date: \(request.lendingDate)")
                                    Spacer()
                                    
                                }
                                .padding()
                                VStack(alignment: .leading, spacing: 20){
                                    // User details
                                    Text("Requested by: \(request.requesterName)")
                                    Text("User ID: \(request.requesterID)")
                                    
                                    // Dates
                                    
                                    Text("Return Date: \(request.returnDate)")
                                    Spacer()
                                    // Buttons for accepting and rejecting the request
                                    HStack {
                                        Button(action: {
                                            // Action for accepting request
                                        }) {
                                            Text("Accept")
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(Color.green)
                                                .cornerRadius(8)
                                        }
                                        Button(action: {
                                            // Action for rejecting request
                                        }) {
                                            Text("Reject")
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(Color.red)
                                                .cornerRadius(8)
                                        }
                                    }
                                }.padding()
                                
                            }
                    }
                    
                }
            }.padding()
            
        }
        .padding()
        .background(Color(Color(red: 0.94, green: 0.92, blue: 1)))
        .cornerRadius(12)
        .shadow(radius: 0)
    }
}

struct BooksRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let books: [Book] = [
            Book(author_name: "Author 1", book_name: "Book 1", category: "Category 1", cover_url: "cover1.png", isbn: "123456789", library_id: "Library 1", loan_id: "Loan 1", quantity: 1, thumbnail_url: "thumbnail1.png"),
            Book(author_name: "Author 2", book_name: "Book 2", category: "Category 2", cover_url: "cover2.png", isbn: "987654321", library_id: "Library 2", loan_id: "Loan 2", quantity: 1, thumbnail_url: "thumbnail2.png"),
            Book(author_name: "Author 3", book_name: "Book 3", category: "Category 3", cover_url: "cover3.png", isbn: "123456780", library_id: "Library 3", loan_id: "Loan 3", quantity: 1, thumbnail_url: "thumbnail3.png"),
            Book(author_name: "Author 4", book_name: "Book 4", category: "Category 4", cover_url: "cover4.png", isbn: "987654322", library_id: "Library 4", loan_id: "Loan 4", quantity: 1, thumbnail_url: "thumbnail4.png"),
            Book(author_name: "Author 5", book_name: "Book 5", category: "Category 5", cover_url: "cover5.png", isbn: "123456781", library_id: "Library 5", loan_id: "Loan 5", quantity: 1, thumbnail_url: "thumbnail5.png"),
            Book(author_name: "Author 6", book_name: "Book 6", category: "Category 6", cover_url: "cover6.png", isbn: "987654323", library_id: "Library 6", loan_id: "Loan 6", quantity: 1, thumbnail_url: "thumbnail6.png"),
            Book(author_name: "Author 7", book_name: "Book 7", category: "Category 7", cover_url: "cover7.png", isbn: "123456782", library_id: "Library 7", loan_id: "Loan 7", quantity: 1, thumbnail_url: "thumbnail7.png")
        ]

        let requests: [BooksRequest] = [
            BooksRequest(id: UUID(), bookISBN: "123456789", requesterName: "John Doe", requesterID: "1234", lendingDate: "2024-05-01", returnDate: "2024-06-01"),
            BooksRequest(id: UUID(), bookISBN: "987654321", requesterName: "Alice Smith", requesterID: "5678", lendingDate: "2024-05-02", returnDate: "2024-06-02"),
            BooksRequest(id: UUID(), bookISBN: "123456780", requesterName: "Bob Johnson", requesterID: "91011", lendingDate: "2024-05-03", returnDate: "2024-06-03"),
            BooksRequest(id: UUID(), bookISBN: "987654322", requesterName: "Emily Brown", requesterID: "121314", lendingDate: "2024-05-04", returnDate: "2024-06-04"),
            BooksRequest(id: UUID(), bookISBN: "123456781", requesterName: "Michael Wilson", requesterID: "151617", lendingDate: "2024-05-05", returnDate: "2024-06-05"),
            BooksRequest(id: UUID(), bookISBN: "987654323", requesterName: "Sophia Taylor", requesterID: "181920", lendingDate: "2024-05-06", returnDate: "2024-06-06"),
            BooksRequest(id: UUID(), bookISBN: "123456782", requesterName: "Emma Garcia", requesterID: "212223", lendingDate: "2024-05-07", returnDate: "2024-06-07")
        ]

        return BooksRequestView(requests: requests, books: books)
    }
}
