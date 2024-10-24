//
//  AccountScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import SwiftUI

struct AccountView: View{
    @EnvironmentObject var profile: UserProfile
    @StateObject var journalData: JournalDataManager
    @StateObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing:0){
            List {
                Section(header: Text("PROFILE")){
                    profileSection()
                }
                
                Section(header: Text("ACTIVITY")){
                    userData(journalData: journalData, locationManager: locationManager)
                }
                
                Section(header: Text("APP SETTING")) {
                    appSettingSection()
                }
                
                Section(header: Text("MORE INFORMATION")) {
                    moreInfoSection()
                    helpFeedbackSection()
                }
                
                Section(header: Text("ABOUT")) {
                    aboutSection()
                }
                
                Section(header: Text("Mail")) {
                    mailSection()
                }
                
                Section{
                    manageSection()
                }
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.automatic)
        .font(.subheadline)
        .onAppear{ self.profile.reload() }
    }
}

struct profileSection: View{
    @EnvironmentObject var profile: UserProfile
//    @State var showMembershipSheet: Bool = false
    
    var body: some View{
        SagaID
        Username
        Email
        Pasword
        AccountCreated
    }
    
    private var SagaID: some View{
        NavigationLink(destination: UIDSettings()) {
            Text("Saga ID")
                .foregroundColor(Color.Default)
            Spacer()
            Text("\(profile.profile.UserID))")
                .foregroundColor(Color.Theme)
                .lineLimit(1)
        }
    }
    
    private var Username: some View{
        NavigationLink(destination: UsernameSettings()) {
            HStack{
                Text("Username")
                    .foregroundColor(Color.Default)
                Spacer()
                Text("\(profile.profile.Username)")
                    .foregroundColor(Color.Theme)
                    .lineLimit(1)
            }
        }
    }
    
    private var Email: some View{
        NavigationLink(destination: EmailSettings()) {
            HStack{
                Text("Email")
                    .foregroundColor(Color.Default)
                Spacer()
                Text("\(profile.profile.Email)")
                    .foregroundColor(Color.Theme)
                    .lineLimit(1)
            }
        }
    }
    
    private var Pasword: some View{
        NavigationLink(destination: PasswordSettings()) {
            HStack{
                Text("Password")
                    .foregroundColor(Color.Default)
                Spacer()
                Text("*********************")
                    .foregroundColor(Color.Theme)
                    .lineLimit(1)
            }
        }
    }
    
    private var AccountCreated: some View{
        HStack{
            Text("Account Created")
                .foregroundColor(Color.Default)
            Spacer()
            Text("\(profile.profile.AccountCreationDateString)")
                .foregroundColor(Color.Default)
                .lineLimit(1)
        }
    }
}

struct userData: View{
    @StateObject var journalData: JournalDataManager
    @StateObject var locationManager: LocationManager
    
    var body: some View{
        Section{
            HStack{
                Text("All Journals")
                    .foregroundColor(Color.Default)
                Spacer()
                
                Text("\(journalData.countAllJournal ?? 0)")
                    .foregroundColor(Color.Default)
                    .lineLimit(1)
            }
            
            HStack{
                Text("Favorite Journals")
                    .foregroundColor(Color.Default)
                Spacer()
                Text("\(journalData.countFavoriteJournal ?? 0)")
                    .foregroundColor(Color.Default)
                    .lineLimit(1)
            }
            
//            NavigationLink(destination: {
//                locationView
//            }) {
//                HStack{
//                    Text("Locations")
//                        .foregroundColor(Color.Default)
//                    Spacer()
//                }
//            }
        }
    }
    
    var locationView: some View{
        Text("Hello World!")
    }
}

struct appSettingSection: View{
    @AppStorage("applyHaptics") var applyHaptics: Bool = true
    @AppStorage("useFaceID") var useFaceID: Bool = false
    
    @State var changePasscode: Bool = false
    @StateObject var AppSettings: AppSettingsViewModel = AppSettingsViewModel()
    @StateObject var allNotification: Notification = Notification()
    
    var body: some View{
        NavigationLink(destination: {
            notificationView
        }) {
            HStack{
                Text("Notification")
                    .foregroundColor(Color.Default)
                Spacer()
            }
        }
        
        Toggle("Haptics", isOn: $applyHaptics)
            .foregroundColor(Color.Default)
        
        Toggle("Face ID", isOn: $useFaceID)
            .foregroundColor(Color.Default)
            .onChange(of: useFaceID, perform: { _ in
                if useFaceID{
                    changePasscode.toggle()
                }
            })
            .sheet(isPresented: $changePasscode) {
                NavigationView{
                    CreatePasscodeView(changePasscode: $changePasscode)
                }
                .interactiveDismissDisabled()
            }
    }
    
    var notificationView: some View{
        VStack{
            List{
                Section{
                    Text("When you're feeling inspired and motivated, it's easy to write. But what happens when you aren't? Developing a writing schedule and setting aside time for journaling can help you stay on track, especially on days when you're feeling uninspired.")
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                }
                
                if allNotification.permission == .denied {
                    Section{
                        Text("Please Authorize Notifications for Saga from System Settings.")
                        Text("Open System Settings")
                            .foregroundColor(Color.red)
                            .onTapGesture {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                    }
                } else{
                    ForEach(allNotification.notifications, id: \.identifier) { notification in
                        Section{
                            HStack{
                                Text(notification.body)
                            }
                            .multilineTextAlignment(.leading)
                            HStack{
                                Text("Remind me at")
                                Spacer()
                                Text(notification.time, style: .time)
                            }
                            .opacity(0.5)
                        }
                    }
                }
            }
        }
        .navigationTitle("Notification")
        .navigationBarTitleDisplayMode(.large)
        .onAppear{
            allNotification.reload()
        }
    }
}


struct moreInfoSection: View{
    var body: some View{
        Link(destination: URL(string: "https://sites.google.com/view/saga-mystory/privacypolicy/v1-0")!) {
            HStack{
                Text("Privacy Policy")
                    .foregroundColor(Color.Default)
                Spacer()
            }
        }
        Link(destination: URL(string: "https://sites.google.com/view/saga-mystory/terms-of-service/v1-0")!) {
            HStack{
                Text("Terms of Service")
                    .foregroundColor(Color.Default)
                Spacer()
            }
        }
    }
}

struct helpFeedbackSection: View{
    var body: some View{
//        Button(action:{
//
//        }){
//            HStack{
//                Text("Help")
//                    .foregroundColor(Color.Default)
//                Spacer()
//            }
//        }
//
//        Button(action:{
//
//        }){
//            HStack{
//                Text("Feedback")
//                    .foregroundColor(Color.Default)
//                Spacer()
//            }
//        }
//
        Button(action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }) {
            HStack{
                Text("System Settings")
                    .foregroundColor(Color.Default)
                Spacer()
            }
        }
    }
}


struct mailSection: View {
    @EnvironmentObject var profile: UserProfile
    @State private var mailData = ComposeMailData(
        subject: "Request Features!",
        recipients: ["Saga.MyStory@gmail.com"],
        message:
            """
            """
    )
    
    @State var isShowingMailView = false
    
    
    
    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        }) {
            Text("Request Features")
        }
        .disabled(!MailView.canSendMail)
        .sheet(isPresented: $isShowingMailView) {
            MailView(data: $mailData) { result in
                print(result)
            }
        }
        .onAppear{
            self.mailData = ComposeMailData(
                subject: "Request Features!",
                recipients: ["Saga.MyStory.Help@gmail.com"],
                message:
                    """
                                
                    Saga ID: \(profile.profile.UserID)
                    UserName: \(profile.profile.Username)
                    Email Address: \(profile.profile.Email)
                    Account Created: \(profile.profile.AccountCreationDateString)
                    
                    """
            )
        }
    }
}

private struct aboutSection: View{
    var body: some View{
        HStack {
            Text("Version")
            Spacer()
            Text("1.0")
                .opacity(0.5)
        }
    }
}

private struct manageSection: View{
    @State private var signOutAlert = false
    @State private var deActivateAlert = false
    
    var body: some View{
        signOutSectionView(signOutAlert: $signOutAlert)
        deactivateSectionView(deActivateAlert: $deActivateAlert)
    }
}

private struct signOutSectionView: View{
    @StateObject var AppSettings: AppSettingsViewModel = AppSettingsViewModel()
    @EnvironmentObject var profile: UserProfile
    @Binding var signOutAlert: Bool
    
    var body: some View{
        Button(action:{
            signOutAlert = true
        }){
            HStack{
                Text("Sign Out")
                    .foregroundColor(Color.red)
                Spacer()
            }
        }
        .alert("Are you sure you want to Sign Out from your account?", isPresented: $signOutAlert) {
            Button("Sign Out", role: .cancel) {
                profile.signOutUser { error in
                    guard error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        profile.RestoreDefault()
                        AppSettings.RestoreAppDefault()
                    }
                }
            }
            Button("Cancel", role: .destructive) { }
        }
    }
}

private struct deactivateSectionView: View{
    @Binding var deActivateAlert: Bool
    
    var body: some View{
        NavigationLink(destination: DeActivateAccountSettings()){
            HStack{
                Text("DeActivate Account")
                    .foregroundColor(Color.red)
                Spacer()
            }
        }
    }
}
