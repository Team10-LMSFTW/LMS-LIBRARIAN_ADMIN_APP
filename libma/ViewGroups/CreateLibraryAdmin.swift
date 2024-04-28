import SwiftUI

struct CreateLibraryAdmin: View {
    @Binding var isLoggedIn: Bool
    @State private var libID = ""
    @State private var emailAddress = ""
    @State private var firstName = ""
    @State private var lastName = ""

    let libraries = ["Library 1", "Library 2", "Library 3", "Library 4", "Library 5", "Library 6"]

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    CreateLibraryView(libID: $libID, emailAddress: $emailAddress, firstName: $firstName, lastName: $lastName)
                    ExistingLibrariesView(libraries: libraries)
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

struct CreateLibraryView: View {
    @Binding var libID: String
    @Binding var emailAddress: String
    @Binding var firstName: String
    @Binding var lastName: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Create Your Library")
                .font(.headline)
                .padding(.bottom)

            TextField("LIB_ID", text: $libID)
                .frame(width: 200)
                .padding()
                .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                .cornerRadius(8.078)

            // Other text fields...

            Button(action: {
                // Assign action
            }) {
                Text("Create")
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

struct ExistingLibrariesView: View {
    let libraries: [String]

    var body: some View {
        VStack(spacing: 16) {
            Text("Existing Libraries")
                .font(.headline)
                .padding(.bottom)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(libraries, id: \.self) { library in
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                            Text(library)
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
        .frame(height: 200)
    }
}

struct CreateYourLibrary_Previews: PreviewProvider {
    static var previews: some View {
        CreateLibraryAdmin(isLoggedIn: .constant(true))
    }
}
