//
//  SagaApp.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/13/22.
//

import SwiftUI
import Firebase

@main
struct SagaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(UserProfile())
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait //By default you want all your views to rotate freely
 
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
