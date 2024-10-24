//
//  DeActivateAccountSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/15/22.
//

import SwiftUI

struct DeActivateAccountSettings: View {
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var AppSettings: AppSettingsViewModel = AppSettingsViewModel()
    
    @State private var email: String = ""
    @State private var pwd: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greeting()
            Spacer()
            emailField(email: $email)
            pwdField(pwd: $pwd)
            Spacer()
            DeActivateAccountBtn(email: $email, pwd: $pwd)
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
            Text("DeActivate Account!")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
            Text("@\(profile.profile.Email)")
                .font(.system(.caption2, design: .rounded))
        }
    }
}

private struct DeActivateAccountBtn: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var profile: UserProfile
    @StateObject var AppSettings: AppSettingsViewModel = AppSettingsViewModel()
    
    @Binding var email: String
    @Binding var pwd: String
    
    @State private var alert = ( showAlert : false, title: "Error", message: "" )
    
    var body: some View{
        Button(action:{
            alert = ( showAlert : false, title: "Error", message: "" )
            
            profile.deactivateAccount(email, pwd, profile.profile.UserID) { error in
                guard let err = error else{
                    alert.showAlert = true
                    alert.title = "Success"
                    alert.message = "Account is Successfully Deactivated"
                    profile.signedIn = false
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
        Text("DeActivate Account")
            .font(.system(.subheadline, design: .rounded))
            .padding()
            .padding(.horizontal)
            .background(Color.Theme)
            .foregroundColor(Color.DefaultAlter)
            .cornerRadius(25)
            .padding()
    }
}
