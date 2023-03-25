//
//  TabManager.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/3/22.
//

import SwiftUI

struct TabManager: View{
    @StateObject var journalData: JournalDataManager
    
    @AppStorage("policyVersion") var policyVersion: Double = 0.0
    @State private var showUpdatePolicySheet: Bool = false
    
    
    var body: some View{
        HomeScreen(journalData: journalData)
//            .onAppear{
//                if policyVersion < PolicyVersion(){
//                    showUpdatePolicySheet = true
//                }
//            }
//            .sheet(isPresented: $showUpdatePolicySheet) {
//                PolicyView()
//            }
    }
}


//            switch selectedTab {
//            case "Location":
//                JournalLocationTab(journalData: journalData)
//            case "Gallery":
//                ImageTab(journalData: journalData, imageModel: imageModel, showLoading: $showLoading)
//            case "Journal":
//                HomeScreen(journalData: journalData)
//            case "Account":
//                AccountView(userProfile: userProfile, journalData: journalData)
//            default:
//                HomeScreen(journalData: journalData)
//            }

//            Tabs(selectedTab: $selectedTab)



//
//private struct Tabs: View{
//    @Binding var selectedTab: String
//
//    var body: some View{
//        HStack(spacing:0){
//            Tab(img: "mappin.and.ellipse", label: "Location", selectedTab: $selectedTab)
//            Tab(img: "photo.on.rectangle", label: "Gallery", selectedTab: $selectedTab)
//            Tab(img: "text.book.closed", label: "Journal", selectedTab: $selectedTab)
//        }
//        .frame(width: CGFloat(screenWidth()), height: CGFloat(screenHeight()/10))
//        .background(
//            Color("Theme.Screen.BG")
//                .opacity(0.5)
//        )
//    }
//}
//
//private struct Tab: View {
//    var img: String
//    var label: String
//
//    @Binding var selectedTab: String
//
//    var body: some View{
//        VStack{
//            Image(systemName: "\(img)")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: CGFloat(screenWidth()/3), height: CGFloat(screenHeight()/40))
//            Text("\(label)")
//                .font(.system(.caption, design: .rounded))
//        }
//        .foregroundColor(Color(selectedTab == label ? "Theme.Button.BG" : "Theme.Text.FG"))
//        .background(
//            Color("Theme.Screen.BG")
//                .opacity(0.5)
//        )
//        .padding(.bottom)
//        .opacity(selectedTab == label ? 1.0 : 0.5)
//        .onTapGesture {
//            Haptics()
//            selectedTab = label
//        }
//    }
//}
