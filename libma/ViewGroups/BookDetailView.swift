//
//  BookDetailView.swift
//  libma
//
//  Created by mathangy on 29/04/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookDetailView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: book.coverURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)

            Text("Book Name: \(book.bookName)")
                .font(.headline)
            Text("Author Name: \(book.authorName)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Category: \(book.category)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("ISBN: \(book.isbn)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Library ID: \(book.libraryID)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Loan ID: \(book.loanID)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Quantity: \(book.quantity)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle(book.bookName)
    }
}

