import SwiftUI
import FirebaseFirestore
import Neumorphic
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
    
    let cornerRadius : CGFloat = 15
    let mainColor = Color.Neumorphic.main
    let secondaryColor = Color.Neumorphic.secondary

    var body: some View {
        
        ScrollView {
            HStack {
                    VStack {
                        Text("Add Book")
                            .font(.system(size: 45, weight: .semibold))
                                                .foregroundColor(Color(hex: 0x3B3D60))
                                                .padding()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 800, height: 950)
                            .foregroundColor(Color(hex: 0xF4F5FA))
                            .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                            .softOuterShadow()
                            .overlay(
                                VStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Book Name")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter Book Name", text: $bookName)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                    }
                                    .padding()
                                    .padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Author Name")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter Author Name", text: $authorName)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                    }
                                    .padding()
                                    .padding(.top, -15)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Category")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter Category", text: $category)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                    }.padding()
                                        .padding(.top, -15)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("ISBN")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter ISBN", text: $isbn)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                    }.padding()
                                        .padding(.top, -15)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Library ID")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter Library ID", text: $libraryID)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                    }.padding()
                                        .padding(.top, -15)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Loan ID")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter Loan ID", text: $loanID)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                    }.padding()
                                        .padding(.top, -15)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Quantity")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                        TextField("Enter Quantity", text: $totalquantity)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .softInnerShadow(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)),radius: 10)
                                            .keyboardType(.numberPad)
                                    }.padding()
                                        .padding(.top, -15)
                                    
                                    Button(action: { addBook() }) {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 150, height: 50)
                                            .foregroundColor(Color.green.opacity(0.9))
                                            .softOuterShadow()
                                            .overlay(
                                                VStack(spacing: 20) {
                                                    Text("Add Book")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.white)
                                                }
                                                .padding()
                                            )
                                    }
                                    .padding()

//                                    .softButtonStyle(RoundedRectangle(cornerRadius: 20),mainColor: Color.green.opacity(0.9), textColor: Color.white, pressedEffect: .flat)
//                                    .padding()
                                    //.position(CGPoint(x: 350.0, y: 50.0))
                                    
                                }
                                .padding()
                                .frame(maxWidth: 700) // Adjust the maximum width of the form
//                                .background(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .fill(Color(red: 0.94, green: 0.92, blue: 1))
//                                        .softOuterShadow())

                                    .padding()
                            )
                                            }
                    .padding()
                    .navigationTitle("Add Book")
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Success!!"), message: Text("Book added successfully"), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(maxWidth: .infinity)
                .alignmentGuide(HorizontalAlignment.center) { _ in
                    0 // Center align the HStack
            }
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
            total_quantity: Int(totalquantity) ?? 0, created_at: Timestamp(date: Date())
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
