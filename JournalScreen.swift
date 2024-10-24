////
//  JournalScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/18/22.
//

import UIKit
import SwiftUI
import Firebase

class JournalScreenViewModel: ObservableObject{
    @Published var title: String = ""
    @Published var entry: String = ""
    @Published var emoji: [String]? = nil
    @Published var favorite: Bool = false
    @Published var userImageList: [UIImage] = []
    @Published var documentID: TimeInterval = NSDate().timeIntervalSince1970
    
    @Published var type: JournalScreenViewType = .Create
    
    init(
        title: String = "",
        entry: String = "",
        emoji: [String]? = nil,
        favorite: Bool = false,
        userImageList: [UIImage] = [],
        documentID: TimeInterval = NSDate().timeIntervalSince1970,
        type: JournalScreenViewType = .Create
    ){
        self.title = title
        self.entry = entry
        self.emoji = emoji
        self.favorite = favorite
        self.userImageList = userImageList
        self.documentID = documentID
        
        self.type = type
    }
}

enum JournalScreenViewType {
    case Create, Edit
}

struct JournalScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var JournalScreenVM: JournalScreenViewModel = JournalScreenViewModel()
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject var journalData: JournalDataManager = JournalDataManager()
    
    @State private var showLoading: Bool = false
    @State private var isKeyboardActive: Bool = false
    
    @State private var showAlert = (
        showingAlert : false,
        alertText : ""
    )
    
    @State private var showSheet = (
        Mood: false,
        Location: false,
        Image: false
    )
    
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    private var emojiList: String {
        guard let list = JournalScreenVM.emoji else{
            return ""
        }
        return list.joined(separator: ", ")
    }
    
    var body: some View {
        ZStack{
            VStack{
                List{
                    TitleField
                    EntryField
                    AddOns
                    FavoriteButton
                    
                    if JournalScreenVM.type == .Edit{
                        DeletePostButton
                    }
                }
            }
            if showLoading {
                ProgressView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if self.isKeyboardActive{
                    Button(action:{
                        hideKeyboard()
                    }){
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                } else{
                    Button(action:{
                        showLoading = true
                        ManageAlert(JournalScreenVM: JournalScreenVM, locationManager: locationManager) { error, msg  in
                            DispatchQueue.main.async {
                                if error {
                                    showAlert.alertText = msg
                                    showAlert.showingAlert.toggle()
                                    showLoading = false
                                } else {
                                    showLoading = false
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }) {
                        Text(JournalScreenVM.type == .Create ? "Post" : "Update")
                    }
                }
            }
        }
        .alert(isPresented: $showAlert.showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text("\(showAlert.alertText)"),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)){ _ in
            self.isKeyboardActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)){ _ in
            self.isKeyboardActive = true
        }
    }
    
    var TitleField: some View{
        Section(header: Text("TITLE")){
            TextEditor(text: $JournalScreenVM.title)
        }
    }
    
    var EntryField: some View{
        Section(header: Text("ENTRY"), footer: Text("\(JournalScreenVM.entry.findHashTag().count) HashTags")){
            VStack{
                Text(JournalScreenVM.entry)
                Spacer()
            }
            .frame(height: CGFloat(screenHeight())/2)
            .allowsHitTesting(false)
            .overlay(
                NavigationLink(
                    destination: EntryFieldFullScreen(string: $JournalScreenVM.entry)
                ){
                    EmptyView()
                }.opacity(0)
            )
        }
    }
    
    var AddOns: some View {
        Section{
            AddImage
            AddLocation
            AddFeelings
        }
    }
    
    var AddImage: some View{
        HStack{
            Image(systemName: "photo.fill")
            Text(JournalScreenVM.userImageList.count < 1 ? "Add Image" : "\(JournalScreenVM.userImageList.count) Images")
                .lineLimit(1)
            Spacer()
            if JournalScreenVM.userImageList.count > 0{
                Image(systemName: "xmark")
                    .opacity(0.5)
                    .onTapGesture{
                        JournalScreenVM.userImageList = []
                    }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showSheet.Image.toggle()
        }
        .sheet(isPresented: $showSheet.Image, content: {
            NavigationView{
                AddImgScreen(userImageList: $JournalScreenVM.userImageList)
            }
        })
    }
    
    var AddLocation: some View{
        HStack{
            Image(systemName: "location.fill")
            Text(locationManager.locations.address == "" ? "Add Location" : String(describing: locationManager.locations.address))
                .lineLimit(1)
            Spacer()
            if locationManager.locations.address != "" {
                Image(systemName: "xmark")
                    .opacity(0.5)
                    .onTapGesture{
                        locationManager.requestLocation()
                    }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showSheet.Location.toggle()
        }
        .sheet(isPresented: $showSheet.Location, content: {
            NavigationView{
                LocationScreen(locationManager: locationManager, journalData: journalData)
            }
        })
        
    }
    
    var AddFeelings: some View{
        HStack {
            Image(systemName: "face.dashed.fill")
            
            Text(emojiList.isEmpty ? "Add Feeling": "\(emojiList)")
        
            Spacer()
            if JournalScreenVM.emoji != nil {
                Image(systemName: "xmark")
                    .opacity(0.5)
                    .onTapGesture{
                        JournalScreenVM.emoji = nil
                    }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { showSheet.Mood.toggle() }
        .sheet(isPresented: $showSheet.Mood, content: {
            NavigationView{
                MoodReflectionScreen(JournalScreenVM: JournalScreenVM)
            }
        })
    }
    
    var FavoriteButton: some View{
        Section{
            VStack{
                HStack{
                    Image(systemName: "heart.fill")
                    Toggle("Favorite", isOn: $JournalScreenVM.favorite)
                }
            }
        }
    }
    
    var DeletePostButton: some View {
        Section{
            HStack{
                Spacer()
                Text("Delete Post!")
                    .foregroundColor(Color.red)
                Spacer()
            }
        }
        .onTapGesture{
            JournalDataManager().DeleteData(userID: UserProfile.init().profile.UserID,documentID: JournalScreenVM.documentID) { error, msg in
                if error {
                    showAlert.alertText = String(describing: msg)
                    showAlert.showingAlert.toggle()
                } else {
                    print("Document successfully deleted!")
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

private struct EntryFieldFullScreen : View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showTempleteSheet:Bool = false
    
    @State private var journalPrompts: [Prompts] = load("JournalPrompt.json")
    @State private var selectedJournalPrompts: [Prompts] = []
    
    @Binding var string: String
    @State var sixWordMemiorWords: [String] = ["","","","","",""]
    
    var body: some View{
        List{
            TextEditor(text: $string)
                .modifier(EntryFieldFullScreenStyle(showTempleteSheet: $showTempleteSheet))
                .sheet(isPresented: $showTempleteSheet) {
                    NavigationView{
//                        List{
                            PromptsView(journalPrompts: $journalPrompts, selectedJournalPrompts: $selectedJournalPrompts, showTempleteSheet: $showTempleteSheet, string: $string)
//                            addSixWordsMemoir(showTempleteSheet: $showTempleteSheet, string: $string, sixWordMemiorWords: $sixWordMemiorWords)
//                            JournalTemplate(string: $string, showTempleteSheet: $showTempleteSheet)
//                        }
//                        .navigationTitle("Vision Board")
                    }
                }
        }
    }
}

private func ManageAlert(JournalScreenVM: JournalScreenViewModel, locationManager: LocationManager, completion: @escaping (Bool, String) -> Void) {
    let profile: UserProfile = UserProfile()
    let fileManager = LocalFileManager.instance
    
    if JournalScreenVM.title.components(separatedBy: " ").count < 4 { // 4
        completion(true, "Title must be more than 4 words long!")
    } else if (JournalScreenVM.entry.components(separatedBy: " ").count + JournalScreenVM.entry.components(separatedBy: "\n").count) < 15 { // 15
        completion(true, "Entry must be more than 15 words long!")
    } else{
        var imageURLList:[String] = []
        
        var docData: [String: Any] = [
            "Title" : JournalScreenVM.title,
            "Entry" : JournalScreenVM.entry,
            "HashTag" : JournalScreenVM.entry.findHashTag(removeHash: true),
            "Address" : locationManager.locations.address,
            "Emoji" : JournalScreenVM.emoji,
            "Favorite" : JournalScreenVM.favorite
        ]
        
        if locationManager.locations.address == "" {
            docData["Location"] = GeoPoint(latitude: 0, longitude: 0)
        } else{
            docData["Location"] =  GeoPoint(latitude: locationManager.locations.coordinate.latitude, longitude: locationManager.locations.coordinate.longitude)
        }
        
        if JournalScreenVM.type == .Create{
            for (index, image) in JournalScreenVM.userImageList.enumerated(){
                imageURLList.append("users/\(profile.profile.UserID)/\(JournalScreenVM.documentID)/\(index).jpg")
                fileManager.saveImage(image: image, imageName: "\(index)", folderName: "\(JournalScreenVM.documentID)")
            }
            
            docData["ImageURL"] = imageURLList
            docData["TimeStamp"] =  Timestamp(date: Date())
            docData["documentID"] = JournalScreenVM.documentID
            
            JournalDataManager().PushData(docData: docData, userImageList: JournalScreenVM.userImageList, documentID: docData["documentID"] as! TimeInterval) { (error, msg) in
                DispatchQueue.main.async {
                    if error {
                        completion(error, String(describing: msg!))
                    } else{
                        completion(error, "")
                    }
                }
            }
        } else{
            for (index, image) in JournalScreenVM.userImageList.enumerated(){
                imageURLList.append("users/\(profile.profile.UserID)/\(JournalScreenVM.documentID)/\(index).jpg")
                fileManager.saveImage(image: image, imageName: "\(index)", folderName: "\(JournalScreenVM.documentID)")
            }
            docData["ImageURL"] = imageURLList
            
            JournalDataManager().UpdateData(docData: docData, userImageList: JournalScreenVM.userImageList, documentID: JournalScreenVM.documentID) { (error, msg) in
                DispatchQueue.main.async {
                    if error {
                        completion(error, String(describing: msg!))
                    } else{
                        completion(error, "")
                    }
                }
            }
        }
    }
}



// Styling
private struct EntryFieldFullScreenStyle: ViewModifier {
    @State var isKeyboardActive:Bool = false
    @Binding var showTempleteSheet:Bool
    
    
    func body(content: Content) -> some View {
        return content
            .multilineTextAlignment(.leading)
//            .background(Color.Default)
//            .cornerRadius(10.0)
//            .shadow(radius: 1.0)
//            .padding()
            .navigationTitle("Entry")
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)){ _ in
                self.isKeyboardActive = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)){ _ in
                self.isKeyboardActive = true
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if self.isKeyboardActive{
                        Button(action:{
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }){
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    } else {
                        Button(action:{
                            showTempleteSheet.toggle()
                        }){
                            Image(systemName: "plus")
                        }
                    }
                }
            }
    }
}


