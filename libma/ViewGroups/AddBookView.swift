import SwiftUI
import FirebaseFirestore

struct AddBookView: View {
    @State private var authorName = ""
    @State private var bookName = ""
    @State private var category = ""
    @State private var isbn = ""
    @State private var libraryID = ""
    @State private var loanID = ""
    @State private var quantity = ""
    @State private var showingAlert = false

    var body: some View {
        Form {
            Section(header: Text("Book Details")) {
                TextField("Author Name", text: $authorName)
                TextField("Book Name", text: $bookName)
                TextField("Category", text: $category)
                TextField("ISBN", text: $isbn)
                TextField("Library ID", text: $libraryID)
                TextField("Loan ID", text: $loanID)
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
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
        guard let isbnNumber = Int(isbn) else {
            print("Invalid ISBN")
            return
        }
        
        let coverURL = "https://covers.openlibrary.org/b/isbn/\(isbnNumber)-L.jpg"
        let thumbnailURL = "https://covers.openlibrary.org/b/isbn/\(isbnNumber)-S.jpg"
        
        let db = Firestore.firestore()
        
        let newBook = Book(
            author_name: authorName,
            book_name: bookName,
            category: category,
            cover_url: coverURL,
            isbn: isbn,
            library_id: libraryID,
            loan_id: loanID,
            quantity: Int(quantity) ?? 0,
            thumbnail_url: thumbnailURL
        )
        
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
        isbn = ""
        libraryID = ""
        loanID = ""
        quantity = ""
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
