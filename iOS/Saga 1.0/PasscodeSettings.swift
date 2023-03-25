//
//  PasscodeSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/18/22.
//

import SwiftUI

struct LoginPasscodeView: View {
    @EnvironmentObject var profile: UserProfile
    @AppStorage("appPasscode") var appPasscode: String = ""
    @StateObject var passcode = PasscodeViewModel()
    @StateObject var AppSettings: AppSettingsViewModel
    @State private var alert = ( success : false, error : false )
    
    
    var body: some View {
        passcode.LockScreenUI(try? Security.instance.decrypt(encryptedText: appPasscode, "Saga-myStoryAppPassCode")) { success in
            if success{
                AppSettings.isUnlocked = .success
                alert.success = true
                alert.error = false
            } else{
                alert.success = false
                alert.error = true
            }
        }
        .alert("Multiple Incorrect Passcode Alert", isPresented: $alert.error, actions: {
            Button("Cancel", role: .destructive, action: {})
            Button("Sign Out", role: .cancel, action: {
                profile.signOutUser()
                profile.signedIn = false
                AppSettings.RestoreAppDefault()
            })
        }, message: {
            Text("To reset Screen Lock you can Sign Out Account.")
        })
        .alert(isPresented: $alert.success) { alertMessage("Success", message: "Passcode Matched") }
    }
}

struct CreatePasscodeView: View{
    @AppStorage("useFaceID") var useFaceID: Bool = false
    @AppStorage("appPasscode") var appPasscode: String = ""
    @StateObject var passcode = PasscodeViewModel()
    @Binding var changePasscode: Bool
    
    @State private var alert = ( show : false,  title : "", msg : "" )
    
    var body: some View {
        if useFaceID{
            passcode.CreatePasscodeUI { passcode, success in
                if success{
                    do {
                        try
                        self.appPasscode = Security.instance.encrypt(
                            text: passcode!.joined(separator: ""),
                            "Saga-myStoryAppPassCode"
                        )
                        alert = ( show : true,  title : "Success", msg : "New Passcode Created Successfully" )
                    } catch let error {
                        alert = ( show : true,  title : "Error", msg : error.localizedDescription )
                    }
                } else{
                    alert = ( show : true,  title : "Error", msg : "Create Passcode didn't match Confirm Passcode" )
                }
            }
            .alert(isPresented: $alert.show) {
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.msg),
                    dismissButton: .default(Text("Got it!"), action: {
                        changePasscode.toggle()
                        if alert.title == "Error"{
                            useFaceID.toggle()
                        }
                    })
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        changePasscode.toggle()
                        useFaceID.toggle()
                    }) {
                        Text("Back")
                    }
                }
            }
        }
    }
}



