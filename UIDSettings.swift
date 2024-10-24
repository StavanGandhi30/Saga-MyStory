//
//  UIDSettings.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import SwiftUI

struct UIDSettings: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject var profile: UserProfile
    
    var body: some View {
        Form{
            Section(header: Text("Saga ID")){
                Text(profile.profile.UserID)
                    .foregroundColor(Color.Theme)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{ presentationMode.wrappedValue.dismiss() }
        .interactiveDismissDisabled()
    }
}
