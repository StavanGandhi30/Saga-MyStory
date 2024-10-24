//
//  UsernameSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/15/22.
//

import SwiftUI

struct UsernameSettings: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var newUsername: String = ""
    
    var body: some View {
        VStack{
            Spacer()
            greeting()
            Spacer()
            usernameField(newUsername: $newUsername)
            Spacer()
            Spacer()
            usernameBtn(newUsername: $newUsername)
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
            Text("Update Username!")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
            
            Text("@\(profile.profile.Username)")
                .font(.system(.caption2, design: .rounded))
        }
    }
}

private struct usernameField: View {
    @Binding var newUsername: String
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                Image(systemName: "person.fill")
                    .padding(5)
                ZStack{
                    if newUsername.isEmpty{
                        HStack{
                            Text("New Username")
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    TextField("", text: $newUsername)
                        .font(.subheadline)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .onChange(of: newUsername, perform: {value in
                            newUsername = newUsername.removeWhitespace()
                            newUsername = newUsername.lowercased()
                        })
                }
            }
            Divider()
        }
        .padding(.vertical)
    }
}

private struct usernameBtn: View{
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var newUsername: String
    
    @State private var alert = ( showAlert : false, title: "Error", message: "" )
    
    var body: some View{
        Button(action:{
            alert = ( showAlert : false, title: "Error", message: "" )
            
            profile.updateUsername(newUsername) { error in
                guard let err = error else{
                    alert.showAlert = true
                    alert.title = "Success"
                    alert.message = "Username Updated Successfully"
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
        Text("Update Username")
            .font(.system(.subheadline, design: .rounded))
            .padding()
            .padding(.horizontal)
            .background(Color.Theme)
            .foregroundColor(Color.DefaultAlter)
            .cornerRadius(25)
            .padding()
    }
}
