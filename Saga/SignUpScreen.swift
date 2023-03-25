//
//  SignUpScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/13/22.
//

import SwiftUI

struct SignUpScreen: View {
    @State private var email: String = ""
    @State private var pwd: String = ""
    @State private var confirmPwd: String = ""
    
    @State private var showPolicy: Bool = false
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                greetingMsg(title: "Hey! Welcome", subtitle: "Create an Account, It's Free!!")
                Spacer()
            }
            VStack{
                emailField(email: $email)
                pwdField(pwd: $pwd, pwdTitle: "Password")
                pwdField(pwd: $confirmPwd, pwdTitle: "Confirm Password")
            }
            VStack{
                Spacer()
                SignUpBtn(email: $email, pwd: $pwd, confirmPwd: $confirmPwd)
                Spacer()
                policyBtn(showPolicy: $showPolicy)
                Spacer()
                Divider()
                goToLogInScreen()
            }
        }
        .padding()
    }
}



private struct policyBtn: View{
    @Binding var showPolicy: Bool
    
    var body: some View{
        Text(.init("By creating an account, I agreed to all of Saga's [Privacy Policy](https://sites.google.com/view/saga-mystory/privacypolicy/v1-0) as well as its [Terms of Service](https://sites.google.com/view/saga-mystory/terms-of-service/v1-0)."))
            .font(.caption2)
            .foregroundColor(Color.Default)
    }
}


// Sign Up Screen Functions//
private struct SignUpBtn: View {
    @StateObject var AppSettings: AppSettingsViewModel = AppSettingsViewModel()

    @Binding var email: String
    @Binding var pwd: String
    @Binding var confirmPwd: String
    
    @State private var alert = ( showAlert : false, message: "" )
    
    @State private var showOTPView = false
    
    var body: some View {
        VStack{
            NavigationLink(destination:
                            OTPView(email: $email, pwd: $pwd, showOTPView: $showOTPView, showAlert: $alert.showAlert, message: $alert.message)
                .navigationBarTitleDisplayMode(.inline),
                           isActive: $showOTPView) { EmptyView() }
            
            Button(action:{
                alert = (
                    showAlert : false,
                    message: ""
                )
                
                if email.isEmpty || pwd.isEmpty || confirmPwd.isEmpty {
                    alert.showAlert = true
                    alert.message = "To Continue, You must fill up all required fields!"
                } else if !email.contains("@gmail.com"){
                    alert.showAlert = true
                    alert.message = "Email Address must be valid and should contain \"@gmail.com\" at the end!"
                } else if pwd.count<7 || pwd.count>20{
                    alert.showAlert = true
                    alert.message = "Password must be between 8 to 20 characters long!"
                } else if pwd != confirmPwd {
                    alert.showAlert = true
                    alert.message = "Password field must match your Confirm Password field!"
                } else{
                    showOTPView.toggle()
                }
            }){
                Text("Create Account")
            }
            .buttonStyle(ManageLoginButtonStyle())
            .alert(isPresented: $alert.showAlert) { alertMessage(message: alert.message) }
        }
    }
}

private struct goToLogInScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack{
            Spacer()
            Text("Already have account!")
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

