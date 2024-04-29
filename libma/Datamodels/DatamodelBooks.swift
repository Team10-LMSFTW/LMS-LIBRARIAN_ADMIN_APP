//
//  DatamodelBooks.swift
//  libma
//
//  Created by mathangy on 28/04/24.
//

import Foundation
struct Book: Encodable,Decodable {
    var author_name: String
    var book_name: String
    var category: String
    var cover_url: String
    var isbn: String
    var library_id: String
    var loan_id: String
    var quantity: Int
    var thumbnail_url: String
}
//author_name book_name
//category cover_url
//isbn library_id loan_id quantity thumbnail_url 
