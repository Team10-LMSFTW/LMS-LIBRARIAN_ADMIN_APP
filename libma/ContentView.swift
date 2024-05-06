import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @AppStorage("login_status") var loginStatus: Bool = false
    @State var isLoggedIn: Bool = false
    @State var category: String = ""
    @StateObject var app_state = GlobalAppState()

    var body: some View {
        Group {
            if !isLoggedIn {
                LoginView(globalAppState: app_state, isLoggedIn: $isLoggedIn, category: $category)
                    .environmentObject(app_state)
            } else {
                if category.count > 0 {
                    if category == "Admin" {
                        TabBar()// Show AdminFunctionsFinal directly
                    } else {
                        let loan = Loan(
                            id: nil,
                            book_ref_id: "123",
                            lending_date: Timestamp(date: Date()),
                            due_date: Timestamp(date: Date()),
                            user_id: "user123",
                            penalty_amount: 10,
                            library_id: 1,
                            loan_status: "Active"
                        )
                                
                        // Pass the mock instance to TabBar2
                        TabBar2(requests: loan)
                        // Show other views for non-admin users
                        // You can add code here if needed
                    }
                }
            }
        }
        .onAppear {
            isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if isLoggedIn {
                category = UserDefaults.standard.string(forKey: "category") ?? ""
                print("on appear")
                print(category)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
