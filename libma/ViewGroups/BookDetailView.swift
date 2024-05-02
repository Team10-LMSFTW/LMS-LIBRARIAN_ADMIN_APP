import SwiftUI
import SDWebImageSwiftUI

struct BookDetailView: View {
    let book: Book
//    @Binding var isPresented: Bool
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: book.cover_url))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)

            Text("Book Name: \(book.book_name)")
                .font(.headline)
            Text("Author Name: \(book.author_name)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Category: \(book.category)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("ISBN: \(book.isbn)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Library ID: \(book.library_id)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Loan ID: \(book.loan_id)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Quantity: \(book.quantity)")
                .font(.subheadline)
                .foregroundColor(.gray)
//            Button("Back") {
//                            self.isPresented = false
//                        }
        }
        .padding()
        .navigationTitle(book.book_name)
    }
}

