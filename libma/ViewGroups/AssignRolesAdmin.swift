import SwiftUI

struct AssignRolesAdmin: View {
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var emailAddress = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedCategory = "admin"

    let librarians = ["Librarian 1", "Librarian 2", "Librarian 3", "Librarian 4", "Librarian 5", "Librarian 6"]

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    AssignRolesView(username: $username, emailAddress: $emailAddress, firstName: $firstName, lastName: $lastName, category: $selectedCategory) // Updated to use $selectedCategory
                    LibrarianView(librarians: librarians)
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

struct AssignRolesView: View {
    @Binding var username: String
    @Binding var emailAddress: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var category: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Assign Roles")
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

            TextField("Username", text: $username)
                .frame(width: 200) // Adjust the width as needed
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

struct LibrarianView: View {
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
        .frame(height: 475)
    }
}

struct AssignRolesAdmin_Previews: PreviewProvider {
    static var previews: some View {
        AssignRolesAdmin(isLoggedIn: .constant(true))
    }
}
