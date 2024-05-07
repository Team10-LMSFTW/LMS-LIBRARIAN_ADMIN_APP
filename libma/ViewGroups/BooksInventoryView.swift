//
//  BooksInventoryView.swift
//  libma
//
//  Created by mathangy on 29/04/24.
//

//import SwiftUI
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import SDWebImageSwiftUI
//
//struct BooksInventoryView: View {
//    @State private var books: [Book] = []
//    
//    var body: some View {
////        NavigationView {
////            List(books, id: \.isbn) { book in
////                VStack(alignment: .leading) {
////                    WebImage(url: URL(string: book.cover_url))
////                        .resizable()
////                        .aspectRatio(contentMode: .fit)
////                        .frame(width: 100, height: 100)
////
////                    
////                    VStack(alignment: .leading) {
////                        Text(book.bookName)
////                            .font(.headline)
////                        Text(book.authorName)
////                            .font(.subheadline)
////                            .foregroundColor(.gray)
////                    }
////                }
////            }
////            .navigationTitle("Books Inventory")
////            .onAppear(perform: fetchBooks)
////        }
////    }
////    
//    NavigationView {
//                List(books, id: \.isbn) { book in
//                    NavigationLink(destination: BookDetailView(book: book, isPresented: <#Binding<Bool>#>)) {
//                        VStack(alignment: .leading) {
//                            WebImage(url: URL(string: book.cover_url))
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 100, height: 100)
//
//                            VStack(alignment: .leading) {
//                                Text(book.book_name)
//                                    .font(.headline)
//                                Text(book.author_name)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Books Inventory")
//                .onAppear(perform: fetchBooks)
//            }
//        }
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
//    
////    private func deleteBook(_ book: Book) {
////            let db = Firestore.firestore()
////
////            // Assuming `book` has an `id` property
////            db.collection("books").document(book.id).delete { error in
////                if let error = error {
////                    print("Error removing document: \(error)")
////                } else {
////                    print("Document successfully removed!")
////                    fetchBooks()
////                }
////            }
////        }
//}
//
//struct BooksInventoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        BooksInventoryView()
//    }
//}
import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct InventoryBookViewNew: View {
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
                ForEach(books, id: \.id) { book in
                    Button(action: {
                        self.selectedBook = book
                    }) {
                        AsyncImage(url: URL(string: book.cover_url)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                Color.red
                            case .empty:
                                Color.gray
                            @unknown default:
                                Color.gray 
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
            .padding(.horizontal, 20)
            .padding(.top, 20)
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

struct InventoryBookView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryBookView()
    }
}
