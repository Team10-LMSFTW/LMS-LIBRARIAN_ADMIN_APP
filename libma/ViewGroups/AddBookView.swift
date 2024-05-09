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
    @State private var totalquantity = ""
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Book")
                .font(.title).bold()
                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Book Details")
                    .font(.headline)
                    .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                    .padding()
                
                VStack(spacing: 40) {
                    TextField("Author Name", text: $authorName)
                    TextField("Book Name", text: $bookName)
                    TextField("Category", text: $category)
                    TextField("ISBN", text: $isbn)
                    TextField("Library ID", text: $libraryID)
                    TextField("Loan ID", text: $loanID)
                    TextField("Quantity", text: $totalquantity)
                        .keyboardType(.numberPad)
                }
                .padding()
            }
            
            Button("Add Book") {
                addBook()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
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
            thumbnail_url: thumbnailURL,
            total_quantity: Int(totalquantity) ?? 0
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

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
    }
}
