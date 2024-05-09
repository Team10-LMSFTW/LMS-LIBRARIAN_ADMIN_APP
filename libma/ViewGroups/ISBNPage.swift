import SwiftUI
import Firebase

struct BookDetailsEntryView: View {
    @State private var isbn: String = ""
    @State private var author: String = ""
    @State private var bookName: String = ""
    @State private var category: String = ""
    @State private var coverURL: String = ""
    @State private var createdAt: Date = Date()
    @State private var libraryID: String = ""
    @State private var loanID: String = ""
    @State private var quantity: Int = 0
    @State private var thumbnailURL: String = ""
    @State private var totalQuantity: Int = 0
    
    var body: some View {
        VStack {
            TextField("Enter ISBN", text: $isbn)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                fetchBookDetails()
            }) {
                Text("Fetch Book Details")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Group {
                HStack {
                    Text("Author Name:")
                        .font(.headline)
                    Spacer()
                    Text(author)
                }
                
                HStack {
                    Text("Book Name:")
                        .font(.headline)
                    Spacer()
                    Text(bookName)
                }
                
                HStack {
                    Text("Category:")
                        .font(.headline)
                    Spacer()
                    Text(category)
                }
                
                HStack {
                    Text("Cover URL:")
                        .font(.headline)
                    Spacer()
                    Text(coverURL)
                }
            }
            .padding()
            
            Group {
                HStack {
                    Text("Created At:")
                        .font(.headline)
                    Spacer()
                    DatePicker("", selection: $createdAt)
                }
                
                HStack {
                    Text("Library ID:")
                        .font(.headline)
                    Spacer()
                    TextField("Library ID", text: $libraryID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Loan ID:")
                        .font(.headline)
                    Spacer()
                    TextField("Loan ID", text: $loanID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Quantity:")
                        .font(.headline)
                    Spacer()
                    TextField("Quantity", value: $quantity, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Thumbnail URL:")
                        .font(.headline)
                    Spacer()
                    TextField("Thumbnail URL", text: $thumbnailURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Total Quantity:")
                        .font(.headline)
                    Spacer()
                    TextField("Total Quantity", value: $totalQuantity, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
            .padding()
            
            Button(action: {
                saveBookDetails()
            }) {
                Text("Save Book Details")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle("Book Details Entry")
    }
    
    private func fetchBookDetails() {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)&key=AIzaSyAwg3k9Z2axowORtmqmkpjZZBkdEvPmU5A") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching book details: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonResponse = json as? [String: Any],
                       let items = jsonResponse["items"] as? [[String: Any]],
                       let volumeInfo = items.first?["volumeInfo"] as? [String: Any] {
                        DispatchQueue.main.async {
                            if let authors = volumeInfo["authors"] as? [String] {
                                self.author = authors.joined(separator: ", ")
                            } else {
                                self.author = ""
                            }
                            
                            self.bookName = volumeInfo["title"] as? String ?? ""
                            
                            if let categories = volumeInfo["categories"] as? [String] {
                                self.category = categories.joined(separator: ", ")
                            } else {
                                self.category = ""
                            }
                            
                            if let thumbnailURL = volumeInfo["imageLinks"] as? [String: String],
                               let imageURL = thumbnailURL["thumbnail"] {
                                self.coverURL = imageURL
                            } else {
                                self.coverURL = ""
                            }
                        }
                    }
                } catch {
                    print("Error parsing book details: \(error)")
                }
            }
        }.resume()
    }
    
    private func saveBookDetails() {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document()
        
        let bookData: [String: Any] = [
            "author_name": author,
            "book_name": bookName,
            "category": category,
            "cover_url": coverURL,
            "created_at": createdAt,
            "isbn": isbn,
            "library_id": libraryID,
            "loan_id": loanID,
            "quantity": quantity,
            "thumbnail_url": thumbnailURL,
            "total_quantity": totalQuantity
        ]
        
        bookRef.setData(bookData) { error in
            if let error = error {
                print("Error saving book details: \(error)")
            } else {
                print("Book details saved successfully")
                // Clear the fields after saving
                author = ""
                bookName = ""
                category = ""
                coverURL = ""
                createdAt = Date()
                isbn = ""
                libraryID = ""
                loanID = ""
                quantity = 0
                thumbnailURL = ""
                totalQuantity = 0
            }
        }
    }
}

struct BookDetailsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailsEntryView()
    }
}
