import SwiftUI
import Firebase
import FirebaseFirestoreSwift


// Define a model for the book data
struct CustomBookModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var isbn: String
    var bookName: String
    var quantity: Int
    var category: String
    var libraryID: String
}

// Create a SwiftUI view to display the list of books in a table format
struct CustomBookTableView: View {
    @State private var books: [CustomBookModel] = []
        @State private var searchText: String = ""
        @State var filterOptions: [String] = [] // Change access level to internal
        @State private var selectedFilter: String = "All Categories"
        @State private var showFilterMenu: Bool = false
        @State private var recommendedBooks: [CustomBookModel] = []
        @State private var selectedCategory: String = ""

    var filteredBooks: [CustomBookModel] {
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
                    .padding(.vertical, 9)
                    .padding(.horizontal)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(8)
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
                        .padding(.vertical, 4)
                        .padding(.horizontal)
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
            .padding()

            Table(filteredBooks) {
                TableColumn("ISBN", value: \.isbn)
                TableColumn("Book Name", value: \.bookName)
                TableColumn("Quantity") { book in
                    Text("\(book.quantity)")
                }
                TableColumn("Category", value: \.category)
                TableColumn("Library ID", value: \.libraryID)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()

            // Recommended books section
            VStack(alignment: .leading) {
                Text("Recommended Books")
                    .font(.headline)
                    .padding()

                Picker("Select Category", selection: $selectedCategory) {
                    Text("All Categories").tag("")
                    ForEach(filterOptions.filter { $0 != "All Categories" }, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                CustomRecommendedBooksView(selectedCategory: selectedCategory)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            fetchData()
            fetchFilterOptions()
        }
        .onChange(of: selectedCategory) { _ in
            getRecommendedBooks()
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

                var allBooks: [CustomBookModel] = []

                for document in documents {
                    let data = document.data()

                    guard let isbn = data["isbn"] as? String,
                          let bookName = data["book_name"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let category = data["category"] as? String,
                          let libraryID = data["library_id"] as? String else {
                        continue
                    }

                    let book = CustomBookModel(id: document.documentID,
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
        let subject = selectedCategory.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://openlibrary.org/subjects/\(subject).json"

        print("URL for recommendations:", urlString) // Debugging

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
                // Print the response data for debugging
                let responseString = String(data: data, encoding: .utf8)
                print("Response data:", responseString ?? "No data")

                let jsonResponse = try JSONDecoder().decode(CustomOpenLibraryRecommendationResponse.self, from: data)
                let recommendedBooks = jsonResponse.works.compactMap { work -> CustomBookModel? in
                    guard let title = work.title,
                          let authors = work.authors,
                          let subjects = work.subjects else {
                        return nil
                    }

                    let isbn = work.identifiers?.isbn?.first ?? ""
                    let category = subjects.joined(separator: ", ")
                    let libraryID = "" // You don't have a library ID, so leave it empty

                    return CustomBookModel(id: nil, isbn: isbn, bookName: title, quantity: 1, category: category, libraryID: libraryID)
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

struct CustomBookTableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBookTableView()
    }
}

// Define struct to represent response from Open Library
struct CustomOpenLibraryRecommendationResponse: Codable {
    let works: [CustomOpenLibraryWork]

    struct CustomOpenLibraryWork: Codable {
        let title: String?
        let authors: [CustomOpenLibraryAuthor]?
        let subjects: [String]?
        let identifiers: CustomOpenLibraryIdentifiers?

        struct CustomOpenLibraryAuthor: Codable {
            let name: String?
        }

        struct CustomOpenLibraryIdentifiers: Codable {
            let isbn: [String]?
        }
    }
}

struct CustomRecommendedBooksView: View {
    @State private var recommendedBooks: [CustomBookModel] = []
    var selectedCategory: String

    var body: some View {
        VStack {
            Text("Recommended Books for \(selectedCategory)")
                .font(.title)
                .padding()

            // Recommended books table
            Table(recommendedBooks) {
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
        }
        .onAppear {
            getRecommendedBooks()
        }
    }

    private func getRecommendedBooks() {
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

            // Print the JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response:", jsonString)
            } else {
                print("Unable to convert data to string")
            }

            do {
                let jsonResponse = try JSONDecoder().decode(CustomOpenLibraryRecommendationResponse.self, from: data)
                let recommendedBooks = jsonResponse.works.compactMap { work -> CustomBookModel? in
                    guard let title = work.title,
                          let authors = work.authors,
                          let subjects = work.subjects else {
                        return nil
                    }

                    let isbn = work.identifiers?.isbn?.first ?? ""
                    let category = subjects.joined(separator: ", ")
                    let libraryID = "" // You don't have a library ID, so leave it empty

                    return CustomBookModel(id: nil, isbn: isbn, bookName: title, quantity: 1, category: category, libraryID: libraryID)
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

struct CustomBookTableView_Previews1: PreviewProvider {
    static var previews: some View {
        let sampleFilterOptions = ["Science Fiction", "Fantasy", "Mystery", "Romance", "Thriller"]
        return CustomBookTableView()
            .environment(\.colorScheme, .light)
            .environment(\.sizeCategory, .medium)
            .previewLayout(.sizeThatFits)
            .onAppear {
                CustomBookTableView().filterOptions = sampleFilterOptions
            }
    }
}
