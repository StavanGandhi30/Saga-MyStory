//
//  PasswordSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import SwiftUI

struct PasswordSettings: View {
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var oldPwd: String = ""
    @State private var newPwd: String = ""
    @State private var confirmNewPwd: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greeting()
            Spacer()
            pwdField(pwd: $oldPwd, pwdTitle: "Old Password")
            pwdField(pwd: $newPwd, pwdTitle: "New Password")
            pwdField(pwd: $confirmNewPwd, pwdTitle: "Confirm New Password")
            Spacer()
            UpdatePwdBtn(oldPwd: $oldPwd, newPwd: $newPwd, confirmNewPwd: $confirmNewPwd)
            UpdatePwdWithEmailBtn()
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{ presentationMode.wrappedValue.dismiss() }
        .interactiveDismissDisabled()
    }
}

private struct greeting: View{
    @EnvironmentObject var profile: UserProfile
    
    var body: some View{
        VStack{
            Text("Update Password!")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
            Text("@\(profile.profile.Email)")
                .font(.system(.caption2, design: .rounded))
        }
    }
}

private struct UpdatePwdBtn: View{
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var oldPwd: String
    @Binding var newPwd: String
    @Binding var confirmNewPwd: String
    
    @State private var alert = ( showAlert : false, title: "Error", message: "" )
    
    var body: some View{
        Button(action:{
            alert = ( showAlert : false, title: "Error", message: "" )
            
            profile.updatePassword(oldPwd, newPwd, confirmNewPwd)  { error in
                guard let err = error else{
                    alert.showAlert = true
                    alert.title = "Success"
                    alert.message = "Email Updated Successfully"
                    presentationMode.wrappedValue.dismiss()
                    return
                }
                alert.showAlert = true
                alert.message = err
            }
        }){
            button
        }
        .alert(isPresented: $alert.showAlert) { alertMessage(alert.title, message: alert.message) }
    }
    
    var button: some View{
        Text("Update Password")
            .font(.system(.subheadline, design: .rounded))
            .padding()
            .padding(.horizontal)
            .background(Color.Theme)
            .foregroundColor(Color.DefaultAlter)
            .cornerRadius(25)
            .padding()
    }
}

private struct UpdatePwdWithEmailBtn: View{
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var alert = ( showAlert : false, title: "Error", message: "" )
    
    var body: some View{
        Button(action:{
            alert = ( showAlert : false, title: "Error", message: "" )
            profile.resetPassword(profile.profile.Email) { error in
                guard let err = error else{
                    alert.showAlert = true
                    alert.title = "Success"
                    alert.message = "Check your email to Reset Password"
                    return
                }
                alert.showAlert = true
                alert.message = err
            }
        }){
            Text("Send password reset link to email")
                .font(.system(.caption2, design: .rounded))
        }
        .alert(isPresented: $alert.showAlert) { alertMessage(alert.title, message: alert.message) }
    }
}
