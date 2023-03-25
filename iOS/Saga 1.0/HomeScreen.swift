//
//  HomeScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import SwiftUI


struct HomeScreen: View {
    @StateObject var journalData: JournalDataManager
    @StateObject var locationManager: LocationManager = LocationManager()
    @EnvironmentObject var profile: UserProfile
    @ObservedObject var internet: NetworkMonitor = NetworkMonitor()
    
    @State private var mail = TransactionalMail()
    
    private let verificationCode: Int = Int.random(in: 1000...9999)
    
    
    @State private var showSheet = (
        Account : false,
        Location : false,
        Gallery : false,
        Internet : false
    )
    
    
    var body: some View {
        VStack{
            if journalData.countAllJournal == nil{
                ProgressView()
            } else{
                ScrollView(journalData.countAllJournal == 0 ? [] : .vertical, showsIndicators: false){
                    AddNewButton(locationManager: locationManager, journalData: journalData)
                    Divider()
                    if journalData.countAllJournal != 0 {
                        if journalData.countFavoriteJournal != 0 {
                            FavoriteSectionView(locationManager: locationManager, journalData: journalData)
                        }
                        RecentSectionView(locationManager: locationManager, journalData: journalData)
                    } else{
                        Spacer()
                        HStack{
                            Image(systemName: "rectangle.fill.badge.person.crop")
                                .padding()
                            Text("Add Journal to display it here")
                        }
                        .opacity(0.5)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Saga")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.journalData.reload()
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                LocationViewTab
            }
            ToolbarItem(placement: .navigationBarLeading) {
                ImageViewTab
            }
            ToolbarItem(placement: .navigationBarTrailing){
                if !internet.isConnected{
                    InternetAlertTab
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                AccountViewTab
            }
        }
    }
    
    private var InternetAlertTab: some View{
        Image(systemName: "wifi.slash")
            .foregroundColor(Color.Theme)
            .onTapGesture {
                Haptics()
                self.showSheet.Internet.toggle()
            }
            .alert(isPresented: $showSheet.Internet) {
                Alert(
                    title: Text("Internet Connection Error"),
                    message: Text("Some Features may not be avaible in offline mode."),
                    dismissButton: .default(Text("Got it!"))
                )
            }
    }
    
    private var LocationViewTab: some View{
        Image(systemName: "mappin.and.ellipse")
            .foregroundColor(Color.Theme)
            .onTapGesture {
                Haptics()
                self.showSheet.Location.toggle()
            }
            .onAppear{
                locationManager.requestLocation()
            }
            .sheet(isPresented: $showSheet.Location){
                NavigationView {
                    LocationView(journalData: journalData, locationManager: locationManager)
                        .navigationBarBackButtonHidden(false)
                }
            }
        
    }
    
    private var ImageViewTab: some View{
        Image(systemName: "photo.on.rectangle")
            .foregroundColor(Color.Theme)
            .onTapGesture {
                Haptics()
                self.showSheet.Gallery.toggle()
            }
            .sheet(isPresented: $showSheet.Gallery){
                NavigationView {
                    ImageView(journalData: journalData)
                }
            }
    }
    
    private var AccountViewTab: some View{
        Image(systemName: "person.fill")
            .foregroundColor(Color.Theme)
            .onTapGesture {
                Haptics()
                self.showSheet.Account.toggle()
            }
            .sheet(isPresented: $showSheet.Account) {
                NavigationView {
                    AccountView(journalData: journalData, locationManager: locationManager)
                        .navigationTitle("Account")
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
    }
}

private struct AddNewButton: View{
    @StateObject var locationManager: LocationManager
    @StateObject var journalData: JournalDataManager
    
    var body: some View{
        NavigationLink(destination: {
            JournalScreen()
        }) {
            button
        }
        .onAppear{
            locationManager.requestLocation()
        }
    }
    
    var button: some View{
        VStack(alignment: .leading){
            Text("Anything New?")
                .font(.system(.title2, design: .rounded))
            Text("Write Down Your Thoughts And Feelings To Understand Them More Clearly.")
                .font(.system(.caption2, design: .rounded))
                .opacity(0.5)
        }
        .modifier(AddNewButtonStyle())
    }
}

private struct FavoriteSectionView: View{
    @StateObject var locationManager: LocationManager
    @StateObject var journalData: JournalDataManager
    @State private var searchText = ""
    
    var body: some View{
        VStack{
            header
            content
        }
    }
    
    var header: some View{
        HStack{
            Text("Favorites")
                .font(.system(.subheadline, design: .rounded))
                .bold()
            Spacer()
            NavigationLink(destination: {
                onClick_SeeAll
            }) {
                Text("See All")
                    .font(.system(.caption, design: .rounded))
            }
        }
        .foregroundColor(Color.Default)
        .padding()
    }
    
    var onClick_SeeAll: some View{
        ScrollView{
            ForEach(journalData.JournalDataVar, id: \.id) { data in
                if data.Favorite{
                    if data.HashTag.description.lowercased().contains(searchText.lowercased()) || searchText.isEmpty{
                        NavigationLink(destination: {
                            ViewJournal(data: data, locationManager: locationManager, journalData: journalData)
                        }) {
                            journalListView(data: data, showFavorite: false)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search By HashTag:")
            .padding(.top)
            .navigationTitle("Favorites")
        }
    }
    
    var content: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                eachContent
            }
        }
    }
    
    var eachContent: some View{
        ForEach(journalData.JournalDataVar, id: \.id) { data in
            if data.Favorite{
                NavigationLink(destination: {
                    ViewJournal(data: data, locationManager: locationManager, journalData: journalData)
                }) {
                    VStack{
                        VStack{
                            HStack{
                                Text(data.title)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Spacer()
                        }
                        .font(.system(.subheadline, design: .rounded))
                        .padding()
                        Spacer()
                        VStack{
                            HStack{
                                Text(FirebaseTimeStampToString(TimeStamp: data.TimeStamp, to: "MMM d, yyyy"))
                                Spacer()
                                HStack{
                                    if !data.ImageURL.isEmpty{
                                        Image(systemName: "photo.fill")
                                    }
                                    if data.Location.latitude != 0.0 && data.Location.longitude != 0.0{
                                        Image(systemName: "location.fill")
                                    }
                                    if data.Emoji != nil{
                                        Image(systemName: "face.dashed.fill")
                                    }
                                }
                                .opacity(0.5)
                                
                                Image(systemName: "arrow.right")
                            }
                        }
                        .font(.system(.caption2, design: .rounded))
                        .padding()
                        .background(Color.DefaultAlter.opacity(0.25))
                    }
                    .foregroundColor(Color.DefaultAlter)
                    .lineLimit(2)
                    .background(Color.Theme)
                    .cornerRadius(10)
                    .frame(width: CGFloat(screenWidth())/1.75, height: CGFloat(screenHeight())/5.5, alignment: .topLeading)
                    .padding()
                }
            }
        }
    }
}

private struct RecentSectionView: View{
    @StateObject var locationManager: LocationManager
    @StateObject var journalData: JournalDataManager
    @State private var searchText = ""
    
    var body: some View{
        VStack{
            header
            content
        }
    }
    
    var header: some View{
        HStack{
            Text("Recent")
                .font(.system(.subheadline, design: .rounded))
                .bold()
            Spacer()
            NavigationLink(destination: {
                onClick_SeeAll
            }) {
                Text("See All")
                    .font(.system(.caption, design: .rounded))
            }
        }
        .foregroundColor(Color.Default)
        .padding()
    }
    
    var onClick_SeeAll: some View{
        ScrollView{
            ForEach(journalData.JournalDataVar, id: \.id){ data in
                if data.HashTag.description.lowercased().contains(searchText.lowercased()) || searchText.isEmpty{
                    NavigationLink(destination: {
                        ViewJournal(data: data, locationManager: locationManager, journalData: journalData)
                    }) {
                        journalListView(data: data)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search By HashTag:")
            .padding(.top)
            .navigationTitle("Recent")
        }
    }
    
    var content: some View{
        ForEach(journalData.JournalDataVar, id: \.id){ data in
            VStack{
                NavigationLink(destination: {
                    ViewJournal(data: data, locationManager: locationManager, journalData: journalData)
                }) {
                    journalListView(data: data)
                }
            }
        }
    }
}








// Styling
private struct AddNewButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color.Default)
            .padding()
    }
}
