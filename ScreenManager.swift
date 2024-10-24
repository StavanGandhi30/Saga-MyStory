//
//  ContentView.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/13/22.
//

import SwiftUI
import FirebaseAuth
import LocalAuthentication

struct ScreenManager: View{
    @StateObject var journalData: JournalDataManager
    @EnvironmentObject var profile: UserProfile
    
    var body: some View{
        NavigationView{
            if profile.signedIn {
                Home(journalData: journalData)
            }  else{
                OnBoarding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


private struct Home: View {
    @StateObject var AppSettings: AppSettingsViewModel = AppSettingsViewModel()
    @StateObject var journalData: JournalDataManager
    @EnvironmentObject var account: UserProfile
    @AppStorage("appPasscode") var appPasscode: String = ""
    
    @State private var showAttemptAlert: Bool = false
    @State private var FaceIDAlert: Bool =  false
        
    var body: some View {
        if AppSettings.isUnlocked == .success {
            TabManager(journalData: journalData)
                .onAppear{
                    AppSettings.SetUp(types: [.notification,.location])
                }
        } else{
            LoginPasscodeView(AppSettings: AppSettings)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "faceid")
                            .onTapGesture{
                                if AppSettings.isUnlocked == .unknown{
                                    FaceIDAlert = true
                                } else{
                                    AppSettings.SetUp(types: [.faceID])
                                }
                            }
                    }
                }
                .onAppear{
                    AppSettings.SetUp(types: [.faceID])
                }
                .alert("Error", isPresented: $FaceIDAlert, actions: {
                    Button("Cancel", role: .destructive, action: {})
                    Button("Device Settings", role: .cancel, action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    })
                }, message: {
                    Text("Turn on permission from Device Settings.")
                })
        }
    }
}

struct LogInScreens: View {
    @ObservedObject var internet = NetworkMonitor()
    
    var body: some View {
        if internet.isConnected{
            LogInScreen()
        } else{
            InternetDisconnectedView()
        }
    }
}
