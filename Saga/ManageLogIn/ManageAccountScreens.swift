//
//  ManageAccountScreens.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/13/22.
//

import SwiftUI

struct ManageLogInScreens: View {
    @State var ManageLogIn: String = "LoginScreen"
    
    var body: some View {
        ZStack{
            
            Image("AppBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            switch ManageLogIn {
            case "ManageLogInScreen_1":
                ManageLogInScreen_1(ManageLogIn: $ManageLogIn)
            case "ManageLogInScreen_2":
                ManageLogInScreen_2(ManageLogIn: $ManageLogIn)
            case "LogInScreen":
                LogInScreen(ManageLogIn: $ManageLogIn)
            case "SignInScreen":
                SignInScreen(ManageLogIn: $ManageLogIn)
            default:
                LogInScreen(ManageLogIn: $ManageLogIn)
            }
        }
    }
}

private struct ManageLogInScreen_1: View{
    @Binding var ManageLogIn: String

    var body: some View{
        Text("Screen 1")
    }
}

private struct ManageLogInScreen_2: View{
    @Binding var ManageLogIn: String

    var body: some View{
        Text("Screen 2")
    }
}
