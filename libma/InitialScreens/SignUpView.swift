import SwiftUI
import FirebaseFirestore
import Firebase

struct SignUpView: View {
    @State private var selectedSegment = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var emailAddress = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @ObservedObject var globalAppState: GlobalAppState
    @State private var isActiveLoginView = false
    @Binding public var isLoggedIn: Bool
    @Binding public var category: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: 0xF8F8ED)
                    .edgesIgnoringSafeArea(.all)
                HStack(spacing: 0) {
                    Image("loginwali")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.5)

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.976, green: 0.969, blue: 0.922))
                            .frame(width: geometry.size.width * 0.4)

                        Card(selectedSegment: $selectedSegment, firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, username: $username, password: $password, confirmPassword: $confirmPassword, globalAppState: globalAppState, onSignUpTap: {
                            isActiveLoginView = true
                        }, registerUserfunc: registerUser)
                    }
                    .frame(width: geometry.size.width * 0.4)
                    .padding(.horizontal, 60)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isActiveLoginView) {
            LoginView(globalAppState: globalAppState, isLoggedIn: $isLoggedIn, category: $category)
        }
    }

    struct Card: View {
        @Binding var selectedSegment: Int
        @Binding var firstName: String
        @Binding var lastName: String
        @Binding var emailAddress: String
        @Binding var username: String
        @Binding var password: String
        @Binding var confirmPassword: String
        @State private var navigateToLogin = false // Add this line
        @ObservedObject var globalAppState: GlobalAppState
        let onSignUpTap: () -> Void // Add this line
        let  registerUserfunc: () -> Void
        var body: some View {
            VStack(spacing: 16) {
                Picker("", selection: $selectedSegment) {
                    Text("Admin")
                        .foregroundColor(selectedSegment == 0 ? .purple : .white)
                        .tag(0)
                    Text("Librarian")
                        .foregroundColor(selectedSegment == 1 ? .purple : .white)
                        .tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                )

                SignUpComponents(firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, username: $username, password: $password, confirmPassword: $confirmPassword, onSignUpTap: onSignUpTap, registerUserfunc: registerUserfunc)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
    }

    struct SignUpComponents: View {
        @Binding var firstName: String
        @Binding var lastName: String
        @Binding var emailAddress: String
        @Binding var username: String
        @Binding var password: String
        @Binding var confirmPassword: String
        let onSignUpTap: () -> Void // Add this line
        let registerUserfunc : () -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("First Name")
                    .font(.headline)
                TextField("", text: $firstName)
                    .padding()
                    .frame(height: 50.486)
                    .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                    .cornerRadius(8.078)

                Text("Last Name")
                    .font(.headline)
                TextField("", text: $lastName)
                    .padding()
                    .frame(height: 50.486)
                    .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                    .cornerRadius(8.078)

                Text("Email Address")
                    .font(.headline)
                TextField("", text: $emailAddress)
                    .padding()
                    .frame(height: 50.486)
                    .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                    .cornerRadius(8.078)

                Text("Username")
                    .font(.headline)
                TextField("", text: $username)
                    .padding()
                    .frame(height: 50.486)
                    .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                    .cornerRadius(8.078)

                Text("Password")
                    .font(.headline)
                SecureField("", text: $password)
                    .padding()
                    .frame(height: 50.486)
                    .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                    .cornerRadius(8.078)

                Text("Confirm Password")
                    .font(.headline)
                SecureField("", text: $confirmPassword)
                    .padding()
                    .frame(height: 50.486)
                    .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                    .cornerRadius(8.078)

                Button(action: registerUserfunc) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50.486)
                        .background(Color(red: 0.33, green: 0.25, blue: 0.55))
                        .cornerRadius(8.078)
                        .shadow(color: Color(red: 1.0, green: 0.455, blue: 0.008, opacity: 0.3), radius: 12.117, x: 0, y: 12.117)
                }
                .padding(.horizontal)
                Button(action: onSignUpTap) {
                    Text("If you have an account Log in here")
                        .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    func registerUser() {
        isLoading = true

        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                isLoading = false
                errorMessage = error.localizedDescription
            } else if let authResult = authResult {
                print("User created successfully: \(authResult.user.uid)")
                globalAppState.user_id = authResult.user.uid
                globalAppState.isLoggedIn = true
                saveUserToFirestore(userID: authResult.user.uid)
            }
        }
    }

    func saveUserToFirestore(userID: String) {
        let newUser = GlobalAppState()
        newUser.user_id = userID
        newUser.library_id = "" // Assign library ID if available
        newUser.isLoggedIn = true
        newUser.first_name = firstName
        newUser.last_name = lastName
        newUser.category = selectedSegment == 0 ? "Admin" : "Librarian"
        
        UserDefaults.standard.set(true, forKey: "isloggedIn")
        UserDefaults.standard.set(userID, forKey: "firebaseAuthId")
        UserDefaults.standard.set(selectedSegment == 0 ? "Admin" : "Librarian", forKey: "category")
        UserDefaults.standard.set(firstName, forKey: "first_name")
        UserDefaults.standard.set(lastName, forKey: "last_name")
        UserDefaults.standard.set("", forKey: "library_id")

        
        do {
            try Firestore.firestore().collection("users").document(userID).setData(from: newUser)
            print("User data saved to Firestore successfully")
        } catch let error {
            print("Error saving user data to Firestore: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
}
