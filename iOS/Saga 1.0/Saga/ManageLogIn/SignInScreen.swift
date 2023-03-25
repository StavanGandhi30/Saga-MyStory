//
//  SignInScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/13/22.
//

import SwiftUI

struct SignInScreen: View {
    
    @Binding var ManageLogIn: String
    
    @State private var email: String = ""
    @State private var pwd: String = ""
    @State private var confirmPwd: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greetingMsg()
            emailField(email: $email)
            pwdField(pwd: $pwd)
            pwdField(pwd: $confirmPwd)
            Spacer()
            Button(action: {
                ManageLogIn = "LogInScreen"
            }){
                Text("Log In")
            }
            Spacer()
            
        }
        .padding()
    }
}

private struct greetingMsg: View {
    var body: some View {
        HStack{
            Text("Welcome Back!!")
                .font(.title)
                .padding(.vertical)
            Spacer()
        }
        .padding()
    }
}

private struct emailField: View {
    @Binding var email: String

    var body: some View {
        HStack(spacing: 0){
            Image(systemName: "envelope.fill")
                .padding(5)
            ZStack{
                if email.isEmpty{
                    HStack{
                        Text("Email Address")
                            .font(.subheadline)
                        Spacer()
                    }
                }
                TextField("", text: $email)
                    .font(.subheadline)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
            }
            .padding(.vertical)
        }
        .background(Color("TextFieldColor.Background"))
        .foregroundColor(Color("TextFieldColor.Foreground"))
        .cornerRadius(5.0)
        .padding(.vertical)
    }
}

private struct pwdField: View {
    @Binding var pwd: String

    var body: some View {
        HStack(spacing: 0){
            Image(systemName: "lock.fill")
                .padding(5)
            ZStack{
                
                if pwd.isEmpty{
                    HStack{
                        Text("Password")
                            .font(.subheadline)
                        Spacer()
                    }
                }
                SecureField("", text: $pwd)
                    .font(.subheadline)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
            }
            .padding(.vertical)
        }
        .background(Color("TextFieldColor.Background"))
        .foregroundColor(Color("TextFieldColor.Foreground"))
        .cornerRadius(5.0)
        .padding(.vertical)
    }
}

//
//struct SignInScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInScreen()
//    }
//}
