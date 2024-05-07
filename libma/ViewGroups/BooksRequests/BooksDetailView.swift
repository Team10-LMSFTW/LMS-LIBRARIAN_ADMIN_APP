//import SwiftUI
//import SDWebImageSwiftUI
//
//struct BookDetailView: View {
//    let book: Book
////    @Binding var isPresented: Bool
//    var body: some View {
//        VStack(alignment: .leading) {
//            WebImage(url: URL(string: book.cover_url))
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 200, height: 200)
//
//            Text("Book Name: \(book.book_name)")
//                .font(.headline)
//            Text("Author Name: \(book.author_name)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("Category: \(book.category)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("ISBN: \(book.isbn)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("Library ID: \(book.library_id)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("Loan ID: \(book.loan_id)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("Quantity: \(book.quantity)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
////            Button("Back") {
////                            self.isPresented = false
////                        }
//        }
//        .padding()
//        .navigationTitle(book.book_name)
//    }
//}

import SwiftUI
import SDWebImageSwiftUI

struct BookDetailView: View {
    var book: Book
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title)
                }
                .padding()
                
                Text(book.book_name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Action for cancel button
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        // Action for delete button
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            
            VStack(alignment: .center) {
                WebImage(url: URL(string: book.cover_url))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 350)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
            }
            
            VStack(alignment: .leading, spacing: 20) {
                BookDetailRow(title: "Author:", detail: book.author_name)
                BookDetailRow(title: "ISBN:", detail: book.isbn)
                BookDetailRow(title: "Category:", detail: book.category)
                BookDetailRow(title: "Quantity Available:", detail: "\(book.total_quantity)")
                BookDetailRow(title: "Borrowed Quantity:", detail: "\(book.quantity)")
                BookDetailRow(title: "Status:", detail: book.quantity > 0 ? "Available" : "Unavailable", statusColor: book.quantity > 0 ? .green : .red)
            }
            .padding(.horizontal)
            .background(Color(red: 245/255, green: 243/255, blue: 247/255))
            .cornerRadius(12)
            .shadow(radius: 3)
            
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top) // Set maximum height and top alignment
        .background(Color.white)
        .cornerRadius(20)
        .padding()
        .padding(.bottom, 50) // Adjust space from bottom
    }
}

struct BookDetailRow: View {
    var title: String
    var detail: String
    var statusColor: Color = .black
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 150, alignment: .leading)
            Text(detail)
                .font(.subheadline)
                .foregroundColor(statusColor)
        }
    }
}

//struct BookDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookDetailView(book: Book(author_name: "Author Name", book_name: "Book Title", category: "Category", cover_url: "", isbn: "ISBN", library_id: "Library ID", loan_id: "Loan ID", quantity: 10, thumbnail_url: "", total_quantity: 20))
//    }
//}


//struct BookDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let book = Book(author_name: "Author Name",
//                        book_name: "Book Title",
//                        category: "Fiction",
//                        cover_url: "bookCover",
//                        isbn: "1234567890",
//                        library_id: "Library ID",
//                        loan_id: "Loan ID",
//                        quantity: 5,
//                        thumbnail_url: "thumbnailURL")
//        BookDetailView(book: book)
//            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
//    }
//}

