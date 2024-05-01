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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(books, id: \.isbn) { book in
                    Button(action: {
                        self.selectedBook = book
                    }) {
                        AsyncImage(url: URL(string: book.cover_url)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                Color.red // Placeholder for error state
                            } else {
                                Color.gray // Placeholder for loading state
                            }
                        }
                        .frame(width: 120, height: 180)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .clipped()
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.horizontal,140)
            .padding(.top,150)
            .sheet(item: $selectedBook) { book in
                BookDetailView(book: book)
            }
        }
        .onAppear(perform: fetchBooks)
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
