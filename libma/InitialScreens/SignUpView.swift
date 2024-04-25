//
//  SignUpView.swift
//  libma
//
//  Created by mathangy on 24/04/24.
//

import SwiftUI

struct SignUpView:  View {
    @State private var selectedSegment = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var emailAddress = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
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
                        
                        Card(selectedSegment: $selectedSegment, firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, username: $username, password: $password, confirmPassword: $confirmPassword)
                    }
                    .frame(width: geometry.size.width * 0.4)
                }
            }
            .edgesIgnoringSafeArea(.all)
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
                
                SignUpComponents(firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, username: $username, password: $password, confirmPassword: $confirmPassword)
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
                
                Button(action: {
                    // Sign-up action
                }) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50.486)
                        .background(Color(red: 0.33, green: 0.25, blue: 0.55))
                        .cornerRadius(8.078)
                        .shadow(color: Color(red: 1.0, green: 0.455, blue: 0.008, opacity: 0.3), radius: 12.117, x: 0, y: 12.117)
                }
                .padding(.horizontal)
                
                Button(action: {
                    LoginView()
                }) {
                    Text("If you have an account Log in here")
                        .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.55))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView()
                .previewDevice("iPad Pro (12.9-inch)")
        }
    }
}

#Preview {
    SignUpView()
}
