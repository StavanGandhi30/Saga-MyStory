//
//  LogInScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/13/22.
//

import SwiftUI

struct LogInScreen: View {
    @State private var email: String = ""
    @State private var pwd: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greetingMsg(title: "Welcome Back!", subtitle: "We missed you!!")
            Spacer()
            VStack{
                emailField(email: $email)
                pwdField(pwd: $pwd)
                forgetPwdBtn()
            }
            Spacer()
            LoginBtn(email: $email, pwd: $pwd)
            Spacer()
            Divider()
            goToSignUpScreen()
        }
        .padding()
    }
}




// Login Screen Functions//
private struct LoginBtn: View {
    @EnvironmentObject var profile: UserProfile

    @Binding var email: String
    @Binding var pwd: String
    
    @State private var alert = ( showAlert : false, message: "" )
    
    var body: some View {
        VStack{
            Button("Login", action: {
                alert = (
                    showAlert : false,
                    message: ""
                )
                if email.isEmpty || pwd.isEmpty {
                    alert.showAlert = true
                    alert.message = "To Continue, You must fill up all required fields"
                } else{
                    profile.signInUser(email, pwd) { error in
                        guard error == nil else {
                            alert.showAlert = true
                            alert.message = error!
                            return
                        }
                        DispatchQueue.main.async {
                            profile.signedIn = true
                        }
                    }
                }
            })
            .buttonStyle(ManageLoginButtonStyle())
            .alert(isPresented: $alert.showAlert) { alertMessage(message: alert.message) }
        }
    }
}


private struct forgetPwdBtn: View {
    var body: some View {
        HStack{
            Spacer()
            NavigationLink(destination: {
                ForgotPwdScreen()
                    .navigationBarHidden(true)
            }) {
                Text("Forget Password")
                    .font(.system(.caption2, design: .rounded))
            }
        }
    }
}

private struct goToSignUpScreen: View {
    var body: some View {
        HStack{
            Spacer()
            Text("Don't have account yet!")
            NavigationLink(destination: {
                SignUpScreen()
                    .navigationBarHidden(true)
            }) {
                Text("Create Account")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.Theme)
            }
            Spacer()
        }
        .font(.system(.caption, design: .rounded))
    }
}



