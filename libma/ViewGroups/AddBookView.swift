//
//  AddingBookView.swift
//  libma
//
//  Created by mathangy on 28/04/24.
//
import SwiftUI
import FirebaseFirestore

struct AddBookView: View {
    @State private var authorName = ""
    @State private var bookName = ""
    @State private var category = ""
    @State private var coverURL = ""
    @State private var isbn = ""
    @State private var libraryID = ""
    @State private var loanID = ""
    @State private var quantity = ""
    @State private var thumbnailURL = ""
    @State private var showingAlert = false

    var body: some View {
        Form {
            Section(header: Text("Book Details")) {
                TextField("Author Name", text: $authorName)
                TextField("Book Name", text: $bookName)
                TextField("Category", text: $category)
                TextField("Cover URL", text: $coverURL)
                TextField("ISBN", text: $isbn)
                TextField("Library ID", text: $libraryID)
                TextField("Loan ID", text: $loanID)
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
//                TextField("Thumbnail URL", text: $thumbnailURL)
            }
            
            Section {
                Button("Add Book") {
                    addBook()
                }
            }
        }
        .navigationTitle("Add Book")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success!!"), message: Text("Book added successfully"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func addBook() {
        let db = Firestore.firestore()
        
        let newBook = Book(authorName: authorName,
                           bookName: bookName,
                           category: category,
                           coverURL: coverURL,
                           isbn: isbn,
                           libraryID: libraryID,
                           loanID: loanID,
                           quantity: Int(quantity) ?? 0)
        
        do {
            _ = try db.collection("books").addDocument(from: newBook)
            clearFields()
            showingAlert = true
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    
    
    private func clearFields() {
        authorName = ""
        bookName = ""
        category = ""
        coverURL = ""
        isbn = ""
        libraryID = ""
        loanID = ""
        quantity = ""
//        thumbnailURL = ""
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

