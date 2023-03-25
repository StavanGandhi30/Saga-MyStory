//
//  AppSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/4/22.
//

import Combine
import SwiftUI
import LocalAuthentication

class AppSettingsViewModel: ObservableObject{
    @AppStorage("useFaceID") var useFaceID: Bool = false
    @Published var isUnlocked: FaceIDStatus?
    
    private var deviceLocationService: DeviceLocationService?
    private var tokens: Set<AnyCancellable> = []
    private var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    func SetUp(types: [type]) {
        for type in types {
            if type == .notification{
                self.ObserveNotifications()
            }
            if type == .location{
                self.deviceLocationService = DeviceLocationService.shared
                self.ObserveCoordinateUpdates()
                self.ObserveDeniedLocationAccess()
                self.deviceLocationService!.requestLocationUpdates()
            }
            if type == .faceID{
                if useFaceID{
                    self.FaceID()
                } else {
                    self.isUnlocked = .success
                }
            }
        }
    }
    
    func RestoreAppDefault(){
        UserDefaults.standard.set(true, forKey: "applyHaptics")
        UserDefaults.standard.set(0.0, forKey: "policyVersion")
        UserDefaults.standard.set(false, forKey: "useFaceID")
        UserDefaults.standard.set("", forKey: "appPasscode")
        Notification().cancelAllNotification()
    }
    
    enum FaceIDStatus {
        case success, error, unknown
    }
    
    enum type {
        case notification, location, faceID
    }
}

extension AppSettingsViewModel{
    private func ObserveNotifications() {
        let notification = Notification()
        
        notification.requestAuth { result, success in
            if success{
                notification.addSystemNotifications()
            }
        }
    }

    
    private func ObserveCoordinateUpdates() {
        deviceLocationService!.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    private func ObserveDeniedLocationAccess() {
        deviceLocationService!.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
    
    private func FaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your App."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    self.isUnlocked = .success
                } else {
                    print("\(String(describing: authenticationError))")
                    self.isUnlocked = .error
                }
            }
        } else {
            self.isUnlocked = .unknown
        }
    }
}
