//
//  ManageLoginFunc.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/16/22.
//

import SwiftUI

struct emailField: View {
    @Binding var email: String
    @State var emailTitle: String = "Email Address"
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack(spacing: 0){
                Image(systemName: "envelope.fill")
                    .padding(5)
                ZStack{
                    if email.isEmpty{
                        HStack{
                            Text(emailTitle)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    TextField("", text: $email)
                        .textFieldStyle(ManageLoginTextFieldStyle())
                        .onChange(of: email, perform: {value in
                            email = email.removeWhitespace()
                            email = email.lowercased()
                        })
                }
            }
            Divider()
        }
        .padding(.vertical)
    }
}

struct pwdField: View {
    @Binding var pwd: String
    @State var pwdTitle: String = "Password"
    @State private var showPwd: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                Image(systemName: "lock.fill")
                    .padding(5)
                ZStack{
                    if pwd.isEmpty{
                        HStack{
                            Text("\(pwdTitle)")
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    
                    if showPwd{
                        TextField("", text: $pwd)
                            .textFieldStyle(ManageLoginTextFieldStyle())
                            .onChange(of: pwd, perform: {value in
                                pwd = pwd.removeWhitespace()
                            })
                    } else{
                        SecureField("", text: $pwd)
                            .font(.subheadline)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                            .onChange(of: pwd, perform: {value in
                                pwd = pwd.removeWhitespace()
                            })
                    }
                    HStack{
                        Spacer()
                        Image(systemName: showPwd ? "eye": "eye.slash")
                            .padding(5)
                            .onTapGesture {
                                showPwd.toggle()
                            }
                    }
                }
            }
            Divider()
        }
        .padding(.vertical)
    }
}

struct greetingMsg: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack{
            Text(title)
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
            Text(subtitle)
                .font(.system(.subheadline, design: .rounded))
        }
    }
}
