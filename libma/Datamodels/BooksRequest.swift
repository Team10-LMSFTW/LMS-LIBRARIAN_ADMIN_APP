import SwiftUI
import Firebase
import FirebaseFirestore

struct BooksRequest: Identifiable {
    let id: UUID
    var bookISBN: String
    var requesterName: String
    var requesterID: String
    var lendingDate: String
    var returnDate: String
    
    init(id: UUID = UUID(), bookISBN: String, requesterName: String, requesterID: String, lendingDate: String, returnDate: String) {
        self.id = id
        self.bookISBN = bookISBN
        self.requesterName = requesterName
        self.requesterID = requesterID
        self.lendingDate = lendingDate
        self.returnDate = returnDate
    }
}
