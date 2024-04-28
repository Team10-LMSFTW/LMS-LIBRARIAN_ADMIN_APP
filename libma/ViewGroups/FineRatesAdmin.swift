import SwiftUI

struct FineRatesAdmin: View {
    @Binding var isLoggedIn: Bool
    @State private var fineRatePerWeek = ""
    @State private var emailAddress = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedCategory = "admin"
    @State private var selectedLibrary = "Library 1"
    
    let librarians = ["Librarian 1", "Librarian 2", "Librarian 3", "Librarian 4", "Librarian 5", "Librarian 6"]
    let libraries = ["Library 1", "Library 2", "Library 3"]

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    FineRatesView(fineRatePerWeek: $fineRatePerWeek, emailAddress: $emailAddress, firstName: $firstName, lastName: $lastName, category: $selectedCategory, library: $selectedLibrary, libraries: libraries)
                    ExistingLibrariansView(librarians: librarians)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
            }
            .frame(maxWidth: 800, maxHeight: .infinity)
            .padding(.leading, 220)
        }
        .overlay(
            TabBar()
                .position(x:-48, y:500)
        )
    }
}

struct FineRatesView: View {
    @Binding var fineRatePerWeek: String
    @Binding var emailAddress: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var category: String
    @Binding var library: String
    let libraries: [String]

    var body: some View {
        VStack(spacing: 16) {
            Text("Fine Rates")
                .font(.headline)
                .padding(.bottom)

            Picker("User Category", selection: $category) {
                Text("Admin").tag("admin")
                Text("Librarian").tag("librarian")
                Text("User").tag("user")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            )

            Picker("Libraries", selection: $library) {
                ForEach(libraries, id: \.self) { lib in
                    Text(lib)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            )

            TextField("Fine Rate per week", text: $fineRatePerWeek)
                .frame(width: 200)
                .padding()
                .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                .cornerRadius(8.078)

            // Other text fields...

            Button(action: {
                // Assign action
            }) {
                Text("Assign")
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity, maxHeight: 40)
                    .background(Color(red: 0.33, green: 0.25, blue: 0.55))
                    .cornerRadius(8.078)
                    .shadow(color: Color(red: 1.0, green: 0.455, blue: 0.008, opacity: 0.3), radius: 12.117, x: 0, y: 12.117)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
}

struct ExistingLibrariansView: View {
    let librarians: [String]

    var body: some View {
        VStack(spacing: 16) {
            Text("Existing Libraries")
                .font(.headline)
                .padding(.bottom)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(librarians, id: \.self) { librarian in
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                            Text(librarian)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .frame(height: 350)
    }
}

struct FineRatesAdmin_Previews: PreviewProvider {
    static var previews: some View {
        FineRatesAdmin(isLoggedIn: .constant(true))
    }
}
