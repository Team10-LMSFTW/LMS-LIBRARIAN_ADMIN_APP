import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @State private var selectedSegment = 0
    @State private var email = ""
    @State private var password = ""
    @State private var isActiveSignUpView = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @ObservedObject var globalAppState: GlobalAppState
    @Binding public var isLoggedIn: Bool
    @Binding public var category: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: 0xF8F8ED) // Beige color with hex code F8F8ED
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
                        
                        Card(selectedSegment: $selectedSegment, email: $email, password: $password, isLoggedIn: $isLoggedIn, category: $category, onSignUpTap: {
                            isActiveSignUpView = true
                        }, showAlert: $showAlert, alertMessage: $alertMessage)
                    }
                    .frame(width: geometry.size.width * 0.4)
                    .padding(.horizontal, 50)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isActiveSignUpView) {
            SignUpView(globalAppState: globalAppState, isLoggedIn: $isLoggedIn, category: $category)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Bad Credentials"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct Card: View {
    @Binding var selectedSegment: Int
    @Binding var email: String
    @Binding var password: String
    @Binding public var isLoggedIn: Bool
    @Binding public var category: String
    let onSignUpTap: () -> Void
    @Binding var showAlert: Bool
    @Binding var alertMessage: String

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedSegment) {
                Text("Admin")
                    .foregroundColor(selectedSegment == 0 ? Color(red: 0.33, green: 0.25, blue: 0.55) : .white)
                    .tag(0)
                Text("Librarian")
                    .foregroundColor(selectedSegment == 1 ? Color(red: 0.33, green: 0.25, blue: 0.55) : .white)
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            )
            
            LoginComponents(segment: $selectedSegment, email: $email, password: $password, onSignUpTap: onSignUpTap, isLoggedIn: $isLoggedIn, category: $category, showAlert: $showAlert, alertMessage: $alertMessage)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
}

struct LoginComponents: View {
    public var fsm = FirestoreManager()
    @Binding public var segment: Int
    @Binding var email: String
    @Binding var password: String
    let onSignUpTap: () -> Void
    @Binding public var isLoggedIn: Bool
    @Binding public var category: String
    @StateObject public var app_state = GlobalAppState()
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    func login() {
        let db = Firestore.firestore()
        category = segment == 0 ? "Admin" : "Librarian"
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign-in error:", error.localizedDescription)
                showAlert = true
                alertMessage = "Invalid username or password. Try again or click Forgot password to reset"
            } else if let result = result {
                print("User signed in successfully!")
                db.collection("users").document(result.user.uid).getDocument { (documentSnapshot, error) in
                    if let error = error {
                        print(error)
                        return
                    } else if let documentSnapshot = documentSnapshot {
                        let data = documentSnapshot.data()
                        print(data!["category_type"] as! String)
                        if (data!["category_type"] as! String == category) {
                            let cat = data?["category_type"] as? String
                            let fn = data?["first_name"] as? String
                            let ln = data?["last_name"] as? String
                            let library_id = data?["library_id"] as? String
                            app_state.category = cat!
                            app_state.first_name = fn!
                            app_state.last_name = ln!
                            app_state.library_id = library_id!
                            print(fn, ln, library_id, cat)
                            print(app_state.isLoggedIn)
                            print(app_state.category)
                            UserDefaults.standard.set(true, forKey: "isloggedIn")
                            UserDefaults.standard.set(result.user.uid, forKey: "firebaseAuthId")
                            UserDefaults.standard.set(cat, forKey: "category")
                            UserDefaults.standard.set(fn, forKey: "first_name")
                            UserDefaults.standard.set(ln, forKey: "last_name")
                            UserDefaults.standard.set(library_id, forKey: "library_id")
                            DispatchQueue.main.async {
                                isLoggedIn = true
                            }
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Email ID")
                .font(.headline)
                .padding(.horizontal, 5)
            TextField("Enter your mail id", text: $email)
                .padding()
                .frame(height: 50.486)
                .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                .cornerRadius(8.078).onTapGesture(perform: {
                    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.endEditing(true)

                })
            
            Text("Password")
                .font(.headline)
                .padding(.horizontal, 5)
            SecureField("Password here", text: $password)
                .padding()
                .frame(height: 50.486)
                .background(Color(red: 0.945, green: 0.949, blue: 0.965))
                .cornerRadius(8.078).onTapGesture {
                    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.endEditing(true)

                }
            
            HStack {
                Spacer()
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot Password?")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }

            Button(action: {
                login()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50.486)
                    .background(Color(red: 0.33, green: 0.25, blue: 0.55))
                    .cornerRadius(8.078)
                    .shadow(color: Color(red: 1.0, green: 0.455, blue: 0.008, opacity: 0.3), radius: 12.117, x: 0, y: 12.117)
            }
            .padding(.horizontal)
            
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                
                Text("OR")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                Spacer()
            }
            
            Button(action: {
                onSignUpTap() // Navigate to sign-up view
            }) {
                Text("Don't Have An Account? Sign Up")
                    .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(globalAppState: GlobalAppState(), isLoggedIn: .constant(false), category: .constant(""))
            .previewDevice("iPhone 12")
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

