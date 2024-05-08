import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Define a model for the book data
struct BookModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var isbn: String
    var bookName: String
    var quantity: Int
    var category: String
    var libraryID: String
}

// Create a SwiftUI view to display the list of books in a table format
struct BookTableView: View {
    @State private var books: [BookModel] = []
    @State private var searchText: String = ""
    @State private var filterOptions: [String] = []
    @State private var selectedFilter: String = "All Categories"
    @State private var showFilterMenu: Bool = false
    @State private var recommendedBooks: [BookModel] = []
    
    var filteredBooks: [BookModel] {
        let searchedBooks = searchText.isEmpty ? books : books.filter { book in
            let searchTermLower = searchText.lowercased()
            return book.bookName.lowercased().contains(searchTermLower) ||
            book.isbn.lowercased().contains(searchTermLower) ||
            book.category.lowercased().contains(searchTermLower) ||
            book.libraryID.lowercased().contains(searchTermLower)
        }
        
        if selectedFilter == "All Categories" {
            return searchedBooks
        } else {
            return searchedBooks.filter { $0.category == selectedFilter }
        }
    }
    
    var body: some View {
        VStack {
            Text("Books List")
                .font(.title)
                .padding()
            
            HStack {
                TextField("Search Books...", text: $searchText)
                    .padding(.vertical, 9) // Adjust vertical padding to reduce the size
                    .padding(.horizontal) // Maintain horizontal padding
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9)) // Add white background
                    .cornerRadius(8) // Add corner radius for a rounded look
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    )
                
                Spacer()
                
                Button(action: {
                    showFilterMenu.toggle()
                }) {
                    Text("Filter")
                        .padding(.vertical, 4) // Adjust vertical padding to match the search bar
                        .padding(.horizontal) // Maintain horizontal padding
                }
                .buttonStyle(BorderedButtonStyle())
                .popover(isPresented: $showFilterMenu) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(filterOptions, id: \.self) { option in
                            Button(action: {
                                selectedFilter = option
                                showFilterMenu = false
                            }) {
                                Text(option)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding() // Add padding around the HStack
            
            Table(filteredBooks) {
                TableColumn("ISBN", value: \.isbn)
                TableColumn("Book Name", value: \.bookName)
                TableColumn("Quantity") { book in
                    Text("\(book.quantity)") // Convert Int to String
                }
                TableColumn("Category", value: \.category)
                TableColumn("Library ID", value: \.libraryID)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            
            // Recommended books section
            //            VStack(alignment: .leading) {
            //                Text("Recommended Books")
            //                    .font(.headline)
            //                    .padding()
            //
            //                Table(recommendedBooks) {
            //                    TableColumn("ISBN", value: \.isbn)
            //                    TableColumn("Book Name", value: \.bookName)
            //                    TableColumn("Quantity") { book in
            //                        Text("\(book.quantity)") // Convert Int to String
            //                    }
            //                    TableColumn("Category", value: \.category)
            //                    TableColumn("Library ID", value: \.libraryID)
            //                }
            //                .frame(maxWidth: .infinity, maxHeight: 200)
            //                .padding()
            //            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            fetchData()
            fetchFilterOptions()
            //            getRecommendedBooks()
        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("books")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                var allBooks: [BookModel] = []
                
                for document in documents {
                    let data = document.data()
                    
                    guard let isbn = data["isbn"] as? String,
                          let bookName = data["book_name"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let category = data["category"] as? String,
                          let libraryID = data["library_id"] as? String else {
                        continue
                    }
                    
                    let book = BookModel(id: document.documentID,
                                         isbn: isbn,
                                         bookName: bookName,
                                         quantity: quantity,
                                         category: category,
                                         libraryID: libraryID)
                    
                    allBooks.append(book)
                }
                
                DispatchQueue.main.async {
                    self.books = allBooks
                }
            }
    }
    
    private func fetchFilterOptions() {
        let db = Firestore.firestore()
        db.collection("books")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                var categories: Set<String> = ["All Categories"]
                
                for document in documents {
                    if let category = document.get("category") as? String {
                        categories.insert(category)
                    }
                }
                
                DispatchQueue.main.async {
                    self.filterOptions = Array(categories)
                }
            }
    }
    
    private func getRecommendedBooks() {
        guard let selectedCategory = filterOptions.first(where: { $0 == selectedFilter }) else {
            recommendedBooks = []
            return
        }
        
        let subject = selectedCategory.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://openlibrary.org/subjects/\(subject).json"
        
        guard let url = URL(string: urlString) else {
            recommendedBooks = []
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recommendations: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.recommendedBooks = []
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.recommendedBooks = []
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.recommendedBooks = []
                }
                return
            }
            
            do {
                let jsonResponse = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
                let recommendedBooks = jsonResponse.works.compactMap { work -> BookModel? in
                    guard let title = work.title,
                          let authors = work.authors,
                          let subjects = work.subjects else {
                        return nil
                    }
                    
                    let isbn = work.identifiers?.isbn?.first ?? ""
                    let category = subjects.joined(separator: ", ")
                    let libraryID = "" // You don't have a library ID, so leave it empty
                    
                    return BookModel(id: nil, isbn: isbn, bookName: title, quantity: 1, category: category, libraryID: libraryID)
                }
                
                DispatchQueue.main.async {
                    self.recommendedBooks = recommendedBooks
                }
            } catch {
                print("Error decoding JSON response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.recommendedBooks = []
                }
            }
        }.resume()
    }
}


struct OpenLibraryResponse: Codable {
    let works: [Work]
    
    struct Work: Codable {
        let title: String?
        let authors: [Author]?
        let subjects: [String]?
        let identifiers: Identifiers?
        
        struct Author: Codable {
            let name: String?
        }
        
        struct Identifiers: Codable {
            let isbn: [String]?
        }
    }
}
struct BookTableView_Previews: PreviewProvider {
    static var previews: some View {
        BookTableView()
    }
}

struct BooksResponse: Codable {
    let items: [BookItem]
    
    struct BookItem: Codable {
        let volumeInfo: VolumeInfo?
        
        struct VolumeInfo: Codable {
            let title: String?
            let authors: [String]?
            let categories: [String]?
            let description: String?
            let industryIdentifiers: [IndustryIdentifier]?
            
            struct IndustryIdentifier: Codable {
                let type: String?
                let identifier: String?
            }
        }
    }
}
