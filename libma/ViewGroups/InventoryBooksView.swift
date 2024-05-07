//import SwiftUI
//import FirebaseFirestore
//import SDWebImageSwiftUI
//
//struct InventoryBookView: View {
//    let columns = [
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20)
//    ]
//    
//    @State private var books: [Book] = []
//    @State private var selectedBook: Book? = nil
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("Books Inventory")
//                                    .font(.title)
//                                    .padding(.top, 20)
//                                    .padding(.bottom, 10)
//                
//                LazyVGrid(columns: columns, spacing: 20) {
//                    ForEach(books, id: \.isbn) { book in
//                        Button(action: {
//                            self.selectedBook = book
//                        }) {
//                            AsyncImage(url: URL(string: book.cover_url)) { phase in
//                                if let image = phase.image {
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                } else if phase.error != nil {
//                                    Color.red // Placeholder for error state
//                                } else {
//                                    Color.gray // Placeholder for loading state
//                                }
//                            }
//                            .frame(width: 120, height: 180)
//                            .cornerRadius(12)
//                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
//                            .clipped()
//                            .padding(.horizontal, 20)
//                        }
//                    }
//                }
//                .padding(.horizontal,140)
//                .padding(.top,150)
//                .sheet(item: $selectedBook) { book in
//                    BookDetailView(book: book)
//            }
//            }
//        }
//        .onAppear(perform: fetchBooks)
//    }
//    
//    private func fetchBooks() {
//        let db = Firestore.firestore()
//        
//        db.collection("books").getDocuments { querySnapshot, error in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                if let documents = querySnapshot?.documents {
//                    self.books = documents.compactMap { queryDocumentSnapshot -> Book? in
//                        return try? queryDocumentSnapshot.data(as: Book.self)
//                    }
//                }
//            }
//        }
//    }
//}
//struct AddBookView_Previews4: PreviewProvider {
//    static var previews: some View {
//        InventoryBookView()
//    }
//}


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
//        GridItem(.flexible(), spacing: 20)
//        GridItem(.flexible(), spacing: 20)

    ]
    
    @State private var books: [Book] = []
    @State private var selectedBook: Book? = nil
    @State private var isRefreshing = false // Add a state to control refreshing
    
    var body: some View {
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
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                                    .clipped()
                                            case .failure(_):
                                                Color.white // Placeholder for error state
                                            case .empty:
                                                ProgressView() // Placeholder for loading state
                                            @unknown default:
                                                ProgressView() // Placeholder for unknown state
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
                                                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
                                        )
                                        .padding(8)
                                    } else {
                                        Color.gray
                                            .frame(width: 120, height: 180)
                                            .cornerRadius(12)
                                    }
                                }
                                Text(book.book_name)
                                    .font(.system(size: 16, weight: .bold))
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
        .refreshable { // Add the refreshable modifier
            isRefreshing = true
            fetchBooks()
            isRefreshing = false
        }
        .onAppear(perform: fetchBooks)
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
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

#Preview{
    InventoryBookView()
}
