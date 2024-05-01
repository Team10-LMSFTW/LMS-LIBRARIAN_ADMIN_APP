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
