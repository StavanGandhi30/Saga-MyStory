//
//  emailSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import SwiftUI

struct EmailSettings: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var newEmail: String = ""
    @State private var confirmNewEmail: String = ""
    @State private var pwd: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greeting()
            Spacer()
            emailField(email: $newEmail, emailTitle: "New Email")
            emailField(email: $confirmNewEmail, emailTitle: "Confirm New Email")
            pwdField(pwd: $pwd)
            Spacer()
            UpdateEmailBtn(newEmail: $newEmail, confirmNewEmail: $confirmNewEmail, pwd: $pwd)
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            presentationMode.wrappedValue.dismiss()
        }
        .interactiveDismissDisabled()
    }
}

private struct greeting: View{
    @EnvironmentObject var profile: UserProfile
    
    var body: some View{
        VStack{
            Text("Update Email Address!")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
            Text("@\(profile.profile.Email)")
                .font(.system(.caption2, design: .rounded))
        }
    }
}

private struct UpdateEmailBtn: View{
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var newEmail: String
    @Binding var confirmNewEmail: String
    @Binding var pwd: String
    
    @State private var alert = ( showAlert : false, title: "Error", message: "" )
    
    var body: some View{
        Button(action:{
            alert = ( showAlert : false, title: "Error", message: "" )
            
            if newEmail != confirmNewEmail {
                alert.showAlert = true
                alert.message = "New Email should be same as Confirm New Email"
            } else{
                profile.updateEmail(newEmail, pwd)  { error in
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
            }
        }){
            button
        }
        .alert(isPresented: $alert.showAlert) { alertMessage(alert.title, message: alert.message) }
    }
    
    var button: some View{
        Text("Update Email")
            .font(.system(.subheadline, design: .rounded))
            .padding()
            .padding(.horizontal)
            .background(Color.Theme)
            .foregroundColor(Color.DefaultAlter)
            .cornerRadius(25)
            .padding()
    }
}
