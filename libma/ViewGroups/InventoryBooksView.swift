//
//  InventoryBooksView.swift
//  libma
//
//  Created by kabir on 30/04/24.
//
import SwiftUI

struct InventoryBookView: View {
    let columns = [
        GridItem(.flexible(),spacing: -100),
        GridItem(.flexible(),spacing: -100),
        GridItem(.flexible(),spacing: -100),
        GridItem(.flexible(),spacing: -100),
        GridItem(.flexible(),spacing: -100),
        GridItem(.flexible(),spacing: -100)

    ]
    
    // Example books
    let books = [
        Book(author_name: "Author 1", book_name: "Book 1", category: "Category 1", cover_url: "cover1.png", isbn: "123456789", library_id: "Library 1", loan_id: "Loan 1", quantity: 1, thumbnail_url: "thumbnail1.png"),
        Book(author_name: "Author 2", book_name: "Book 2", category: "Category 2", cover_url: "cover2.png", isbn: "987654321", library_id: "Library 2", loan_id: "Loan 2", quantity: 1, thumbnail_url: "thumbnail2.png"),
        Book(author_name: "Author 1", book_name: "Book 1", category: "Category 1", cover_url: "cover1.png", isbn: "1234356789", library_id: "Library 1", loan_id: "Loan 1", quantity: 1, thumbnail_url: "thumbnail1.png"),
        Book(author_name: "Author 2", book_name: "Book 2", category: "Category 2", cover_url: "cover2.png", isbn: "9874654321", library_id: "Library 2", loan_id: "Loan 2", quantity: 1, thumbnail_url: "thumbnail2.png"),
        Book(author_name: "Author 1", book_name: "Book 1", category: "Category 1", cover_url: "cover1.png", isbn: "125456789", library_id: "Library 1", loan_id: "Loan 1", quantity: 1, thumbnail_url: "thumbnail1.png"),
        Book(author_name: "Author 2", book_name: "Book 2", category: "Category 2", cover_url: "cover2.png", isbn: "9876564321", library_id: "Library 2", loan_id: "Loan 2", quantity: 1, thumbnail_url: "thumbnail2.png"),
        Book(author_name: "Author 1", book_name: "Book 1", category: "Category 1", cover_url: "cover1.png", isbn: "1236456789", library_id: "Library 1", loan_id: "Loan 1", quantity: 1, thumbnail_url: "thumbnail1.png"),
        Book(author_name: "Author 2", book_name: "Book 2", category: "Category 2", cover_url: "cover2.png", isbn: "9876154321", library_id: "Library 2", loan_id: "Loan 2", quantity: 1, thumbnail_url: "thumbnail2.png"),
        Book(author_name: "Author 1", book_name: "Book 1", category: "Category 1", cover_url: "cover1.png", isbn: "1234456789", library_id: "Library 1", loan_id: "Loan 1", quantity: 1, thumbnail_url: "thumbnail1.png"),
        Book(author_name: "Author 2", book_name: "Book 2", category: "Category 2", cover_url: "cover2.png", isbn: "9876546321", library_id: "Library 2", loan_id: "Loan 2", quantity: 1, thumbnail_url: "thumbnail2.png"),
        // Add more books as needed
    ]
    
    var body: some View {
        ZStack {
            TabBar()
                .position(CGPoint(x: 60.0, y: 400.0))
            Button(action: {
                                    // Action when button is tapped
                                }) {
                                    Text("Add New Book")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color(hex: 0x54408C))
                                        .cornerRadius(0)
                                }
                                .padding()
                                .position(CGPoint(x: 1090.0, y: 50.0))
            ScrollView {
                VStack {
                
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(books, id: \.isbn) { book in
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
                            .padding()
                        }
                    }
                    .padding()
                    .position(CGPoint(x: 660.0, y: 300.0))
                }
            }
        }
        
    }
}
struct InventoryBook: PreviewProvider {
    static var previews: some View {
        InventoryBookView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .previewDisplayName("Library Content View")
    }
}
