//import SwiftUI
//import SDWebImageSwiftUI
//struct BookDetailView: View {
//    var book: Book
//    
//    @Environment(\.colorScheme) var colorScheme
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            HStack {
//                Button(action: {
//                    // Action for back button
//                }) {
//                    HStack{
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.black)
//                            .font(.title)
//                        Spacer()
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                .padding()
//                
//                Text(book.book_name)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                
//                
//                HStack{
//                    Button(action: {
//                        
//                    }) {
//                        HStack{
//                            Spacer()
//                            Text("Cancel")
//                                .font(.title3)
//                                .foregroundColor(.black)
//                        }
//                    }
//                    .padding(.trailing, 20)
//                    
//                    Button(action: {
//                    
//                    }) {
//                        HStack{
//                            Text("Delete")
//                                .font(.title3)
//                                .foregroundColor(.red)
//                        }
//                    }
//                    .padding(.trailing, 20)
//                }
//                .frame(maxWidth: .infinity)
//            }
//            
//            VStack(alignment: .leading){
//                WebImage(url: URL(string: book.cover_url))
//                               .resizable()
//                               .aspectRatio(contentMode: .fit)
//                               .frame(width: 200, height: 200)
//            }
//            HStack(spacing: 80) {
//                VStack(alignment: .leading, spacing: 50) {
//                    Text("Author:")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("ISBN:")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("Category:")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("Quantity Available:")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("Borrowed Quantity:")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("Status:")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                }
//                
//                VStack(alignment: .leading, spacing: 50) {
//                    Text(book.author_name)
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text(book.isbn)
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text(book.category)
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("\(book.total_quantity)")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text("\(book.quantity)")
//                        .font(.title3)
//                        .foregroundColor(.black)
//                    Text(book.quantity > 0 ? "Available" : "Unavailable")
//                        .font(.title3)
//                        .foregroundColor(book.quantity > 0 ? .green : .red)
//                }
//            }
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
