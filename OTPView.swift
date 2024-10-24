//
//  OTPView.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/25/22.
//

import SwiftUI

struct OTPView: View {
    @Binding var email: String
    @Binding var pwd: String
    @Binding var showOTPView: Bool
    @Binding var showAlert: Bool
    @Binding var message: String
    
    @EnvironmentObject var profile: UserProfile
    @StateObject private var OTPView = OTPViewModel()
    @State private var alert = ( showAlert : false, message: "" )
    @State private var attempt = 0
    
    private let verificationCode: Int = Int.random(in: 1000...9999)
        
    var body: some View {
        NavigationView {
            OTPView.UI()
                .onChange(of: OTPView.code.count, perform: { newValue in
                    if OTPView.code.count == 4{
                        if String(describing: verificationCode) == OTPView.code.joined() {
                            alert.showAlert = false
                            profile.createUser(email, pwd) { error in
                                guard error == nil else {
                                    showAlert = true
                                    message = error!
                                    return
                                }
                                DispatchQueue.main.async {
                                    profile.signedIn = true
                                }
                            }
                            showOTPView.toggle()
                        } else{
                            attempt += 1
                            alert.showAlert = true
                            alert.message = "Incorrect OTP! Attempt: \(attempt)"
                        }
                    }
                })
                .alert(isPresented: $alert.showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("\(alert.message)"),
                        dismissButton: .default(Text("Okay"), action: {
                            OTPView.code = []
                            if attempt == 5{
                                showOTPView.toggle()
                            }
                        })
                    )
                }
        }
        .onAppear {
            TransactionalMail.send.verificationEmail(email, verificationCode)
        }
    }
}


