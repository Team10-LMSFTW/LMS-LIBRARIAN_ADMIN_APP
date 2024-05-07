//
//  DatamodelBooks.swift
//  libma
//
//  Created by mathangy on 28/04/24.
//

import Foundation
import FirebaseFirestore

struct Book: Encodable, Decodable, Identifiable {
//    var id: String { isbn } //added to give ref integrity
    @DocumentID var id: String?
    var author_name: String
    var book_name: String
    var category: String
    var cover_url: String
    var isbn: String
    var library_id: String
    var loan_id: String
    var quantity: Int
    var thumbnail_url: String
    var total_quantity : Int
    var created_at : Timestamp
}

//author_name book_name
//category cover_url
//isbn library_id loan_id quantity thumbnail_url
