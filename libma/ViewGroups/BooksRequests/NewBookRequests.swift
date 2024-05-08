import SwiftUI
import FirebaseFirestore

struct BookRequest: Identifiable, Codable {
    let id: UUID
    let name: String
    let author: String
    let description: String?
    let edition: String?
    let status: Int
    let category: String?
    let library_id: String?
}

struct NewbookRequestView: View {
    @State private var requests = [BookRequest]()

    var body: some View {
        VStack {
            Text("New Book Requests")
                .font(.largeTitle)
            
            List(requests) { request in
                VStack(alignment: .leading) {
                    Text("Book Name: \(request.name)")
                    Text("Author: \(request.author)")
                    Text("Description: \(request.description ?? "No Description")")
                    Text("Edition: \(request.edition ?? "No Edition")")
                    Text("Status: \(request.status)")
                    Text("Category: \(request.category ?? "No Category")")
                    Text("Library ID: \(request.library_id ?? "No Library ID")")
                }
            }
            .onAppear {
                fetchData()
            }
        }
    }
    
    func fetchData() {
        let db = Firestore.firestore()
        db.collection("requests").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    print(data)
//                    if let id = data["id"] as? String,
                      if let name = data["name"] as? String,
                       let author = data["author"] as? String,
                       let description = data["description"] as? String?,
                       let edition = data["edition"] as? String?,
                       let status = data["status"] as? Int,
                       let category = data["category"] as? String?,
                        let user_id = data["user_id"] as? String?,
                       let library_id = data["library_id"] as? String? {
                        let request = BookRequest(id: UUID(), name: name, author: author, description: description, edition: edition, status: status, category: category, library_id: library_id)
                        self.requests.append(request)
                    }
                }
            }
        }
    }
}
