//
//  BooksInventory.swift
//  libma
//
//  Created by admin on 02/05/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Define a model for the book data
struct BookModel: Identifiable, Codable, Hashable {
    var id: String?
    var isbn: String
    var bookName: String
    var quantity: Int
    var category: String
    var libraryID: String
}



struct BookTableView: View {
    @State private var books: [BookModel] = []
    
    var body: some View {
        VStack {
            Text("Books List")
                .font(.title)
                .padding()
            
            Table(books) {
                TableColumn("ISBN", value: \.isbn)
                TableColumn("Book Name", value: \.bookName)
                TableColumn("Quantity") { book in
                    Text("\(book.quantity)") // Convert Int to String
                }
                TableColumn("Category", value: \.category)
                TableColumn("Library ID", value: \.libraryID)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            // Fetch data from Firebase Firestore initially
            fetchData()
        }
    }
    
    // Fetch data from Firebase Firestore
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("books")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                var allBooks: [BookModel] = []
                
                for document in documents {
                    let data = document.data()
                    
                    guard let isbn = data["isbn"] as? String,
                          let bookName = data["book_name"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let category = data["category"] as? String,
                          let libraryID = data["library_id"] as? String else {
                        continue
                    }
                    
                    let book = BookModel(id: document.documentID,
                                         isbn: isbn,
                                         bookName: bookName,
                                         quantity: quantity,
                                         category: category,
                                         libraryID: libraryID)
                    
                    allBooks.append(book)
                }
                
                // Update the @State variable to trigger UI refresh
                self.books = allBooks
            }
    }
}

// Preview for SwiftUI Canvas
struct BookTableView_Previews: PreviewProvider {
    static var previews: some View {
        BookTableView()
    }
}
