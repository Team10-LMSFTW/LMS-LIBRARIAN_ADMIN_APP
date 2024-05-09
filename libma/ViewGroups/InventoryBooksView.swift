import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct InventoryBookView: View {
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @State private var books: [Book] = []
    @State private var selectedBook: Book? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                        .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("Books Inventory")
                        .font(.largeTitle)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(books, id: \.isbn) { book in
                            Button(action: {
                                self.selectedBook = book
                            }) {
                                VStack {
                                    ZStack(alignment: .bottomTrailing) {
                                        if let url = URL(string: book.cover_url) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 120, height: 180)
                                                        .cornerRadius(12)
                                                    
                                                case .failure(_):
                                                    Color.red
                                                case .empty:
                                                    ProgressView()
                                                @unknown default:
                                                    ProgressView()
                                                }
                                            }
                                            .padding(8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 120, height: 180)
                                                    .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                                                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                                                    .softOuterShadow()
                                                    
                                            )
                                            .padding(8)
                                        } else {
                                            Color.gray
                                                .frame(width: 120, height: 180)
                                                .cornerRadius(12)
                                        }
                                    }
                                    
                                    Text(book.book_name)
                                        .font(.caption)
                                        .bold() // Bold text
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .padding(.top, 4)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .sheet(item: $selectedBook) { selectedBook in
                        BookDetailView(book: selectedBook)
                    }
                }
            }
            .onAppear(perform: fetchBooks)
        }
    }
    
    private func fetchBooks() {
        let db = Firestore.firestore()
        
        db.collection("books").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.books = documents.compactMap { queryDocumentSnapshot -> Book? in
                        return try? queryDocumentSnapshot.data(as: Book.self)
                    }
                }
            }
        }
    }
}

struct BookDetailView: View {
    var book: Book
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? UIColor(hex: "F1F2F7") : UIColor(hex: "323345"))
                        .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                
                VStack {
                    
                    HStack {
                        HStack (alignment: .center) {
                            Text(book.book_name)
                                .font(.system(size: 30, weight: .medium, design: .default))
                                .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                                .padding()
                        }
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Spacer()
                                Text("Cancel")
                                    .font(.title3)
                                    .foregroundColor(colorScheme == .light ? Color(UIColor(hex: "7A9BDD")) : Color(UIColor(hex: "8D89DA")))
                                    .padding()
                            }
                        }
                        .padding(.trailing, 20)
                        
                        Button(action: {
                        
                        }) {
                            HStack {
                                Text("Delete")
                                    .font(.title3)
                                    .foregroundColor(colorScheme == .light ? Color(UIColor(hex: "DF8CB2")) : Color(UIColor(hex: "DE7288")))
                            }
                        }
                        .padding(.trailing, 20)
                    }


                    
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 120, height: 180)
                    .foregroundColor(colorScheme == .light ? Color(hex: "F1F2F7") : Color(hex: "323345"))
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5).blur(radius: 1)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5).blur(radius: 2)
                    .softOuterShadow()
                    .overlay (
                        VStack(alignment: .leading){
                            WebImage(url: URL(string: book.cover_url))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 180)
                                .cornerRadius(12)

                        }
                    )
                    .padding()
                
                HStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 50) {
                        Text("Author:")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("ISBN:")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("Category:")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("Quantity Available:")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("Borrowed Quantity:")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("Status:")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                    }
                    
                    VStack(alignment: .leading, spacing: 50) {
                        Text(book.author_name)
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text(book.isbn)
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text(book.category)
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("\(book.total_quantity)")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text("\(book.quantity)")
                            .font(.title3)
                            .foregroundColor(Color(colorScheme == .light ? UIColor(hex: "3B3D60") : UIColor(hex: "F5F5F6")))
                        Text(book.quantity > 0 ? "Available" : "Unavailable")
                            .font(.title3)
                            .foregroundColor(book.quantity > 0 ? Color(hex: "61A2D9") : Color(hex: "DB6376"))
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview{
    InventoryBookView()
}
