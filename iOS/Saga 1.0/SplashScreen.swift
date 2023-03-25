//
//  SplashScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/2/22.
//

import SwiftUI

struct SplashScreen: View{
    @EnvironmentObject var account: UserProfile
    @ObservedObject var journalData = JournalDataManager()
    @StateObject var OTPView = OTPViewModel()
    @State private var timeRemaining = 1
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        VStack{
            if timeRemaining > 0{
                screen
            } else{
                ScreenManager(journalData: journalData)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: timeRemaining)
        .onAppear{ account.signedIn = account.isSignedIn }
    }
    
    var screen: some View{
        Text("Saga-MyStory")
            .ignoresSafeArea()
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
    }
}



//VStack{
//    Spacer()
//    Text("Keep your thoughts organized")
//        .font(.system(.title, design: .rounded))
//        .fontWeight(.semibold)
//    Spacer()
//    Text("Saga help you to organize your thoughts and make them apprehensible.")
//        .font(.system(.title3, design: .rounded))
//        .fontWeight(.light)
//    Spacer()
//}
//.padding()
