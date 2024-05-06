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
                    HStack{
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
                Text(book.book_name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                
                
                HStack{
                    Button(action: {
                        
                    }) {
                        HStack{
                            Spacer()
                            Text("Cancel")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.trailing, 20)
                    
                    Button(action: {
                    
                    }) {
                        HStack{
                            Text("Delete")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.trailing, 20)
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading){
                WebImage(url: URL(string: book.cover_url))
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 200, height: 200)
            }
            HStack(spacing: 80) {
                VStack(alignment: .leading, spacing: 50) {
                    Text("Author:")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("ISBN:")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("Category:")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("Quantity Available:")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("Borrowed Quantity:")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("Status:")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                
                VStack(alignment: .leading, spacing: 50) {
                    Text(book.author_name)
                        .font(.title3)
                        .foregroundColor(.black)
                    Text(book.isbn)
                        .font(.title3)
                        .foregroundColor(.black)
                    Text(book.category)
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("\(book.total_quantity)")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("\(book.quantity)")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text(book.quantity > 0 ? "Available" : "Unavailable")
                        .font(.title3)
                        .foregroundColor(book.quantity > 0 ? .green : .red)
                }
            }
            .padding(.horizontal, 20)
            .background(Color(red: 245/255, green: 243/255, blue: 247/255))
            .cornerRadius(12)
            .shadow(radius: 3)
            
            Spacer()
        }
        .padding()
    }
}

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
