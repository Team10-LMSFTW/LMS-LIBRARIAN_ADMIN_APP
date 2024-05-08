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
                .padding(.bottom, 20)

            ScrollView {
                VStack {
                    HStack {
                        Text("Book Name")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Author")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Description")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Edition")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Status")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Category")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Library ID")
                            .bold()
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.2))

                    ForEach(requests.indices, id: \.self) { index in
                        RequestRow(request: requests[index], index: index)
                    }
                }
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            fetchData()
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

struct RequestRow: View {
    let request: BookRequest
    let index: Int

    var body: some View {
        HStack(spacing: 0) {
            Text(request.name)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(request.author)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(request.description ?? "No Description")
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(request.edition ?? "No Edition")
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(request.status)")
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(request.category ?? "No Category")
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(request.library_id ?? "No Library ID")
                .padding(.horizontal, 50)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
        .background(index % 2 == 0 ? Color.white : Color(red: 188/255, green: 188/255, blue: 189/255).opacity(0.2)) // Alternating row colors
        .cornerRadius(5)
        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 10)
    }
}

#if DEBUG
struct NewbookRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NewbookRequestView()
    }
}
#endif
