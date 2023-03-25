//
//  forgotPwd.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import SwiftUI

struct ForgotPwdScreen: View {
    @State private var errorForgotPwd: Bool = false
    @State private var successForgotPwd: Bool = false
    
    @State private var email: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greetingMsg(title: "Trouble Logging in!", subtitle: "Forgot Password! We are here to help you!!")
            Spacer()
            emailField(email: $email)
            Spacer()
            ForgotPwdBtn(email: $email, errorForgotPwd: $errorForgotPwd, successForgotPwd: $successForgotPwd)
            Spacer()
            Divider()
            goToMainScreens()
        }
        .padding()
    }
}




// Forgot Password Screen Functions//

private struct goToMainScreens: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack{
            Spacer()
            Text("Back to")
            Text("Login")
                .fontWeight(.semibold)
                .foregroundColor(Color.Theme)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
        }
        .font(.system(.caption, design: .rounded))
    }
}

private struct ForgotPwdBtn: View {
    @EnvironmentObject var profile: UserProfile
    
    @Binding var email: String
    @Binding var errorForgotPwd: Bool
    @Binding var successForgotPwd: Bool
    
    @State private var alert = ( showAlert : false, title: "Error", message: "" )
    
    var body: some View {
        VStack{
            Button("Forgot Password", action:{
                alert = ( showAlert : false, title: "Error", message: "" )
                profile.resetPassword(email) { error in
                    guard let err = error else{
                        alert.showAlert = true
                        alert.title = "Success"
                        alert.message = "Check your email to Reset Password"
                        return
                    }
                    alert.showAlert = true
                    alert.message = err
                }
            })
            .buttonStyle(ManageLoginButtonStyle())
            .alert(isPresented: $alert.showAlert) { alertMessage(alert.title, message: alert.message) }
        }
    }
}
