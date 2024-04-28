//
//  DatamodelBooks.swift
//  libma
//
//  Created by mathangy on 28/04/24.
//

import Foundation
struct Book: Encodable {
    var authorName: String
    var bookName: String
    var category: String
    var coverURL: String
    var isbn: String
    var libraryID: String
    var loanID: String
    var quantity: Int
//    var thumbnailURL: String
}
