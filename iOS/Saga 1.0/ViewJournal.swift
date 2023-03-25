//
//  ViewJournal.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/6/22.
//

import SwiftUI
import MapKit

struct ViewJournal: View{
    var data: JournalDataType
    @StateObject var locationManager: LocationManager
    @StateObject var journalData: JournalDataManager
    
    @State private var TabImageCount = 0
    @State private var Images: [UIImage] = []
    @State private var showLoading: Bool = true
    
    var body: some View{
        ScrollView{
            title
            details
            if data.ImageURL.count != 0 {
                VStack{
                    imageView
                    imageViewButton
                }
            }
            Divider()
            entry
            Spacer()
        }
        .navigationBarTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {
                    if showLoading{
                        ProgressView()
                    } else{
                        JournalScreen(
                            JournalScreenVM: JournalScreenViewModel(title: data.title, entry: data.entry, emoji: data.Emoji, favorite: data.Favorite, userImageList: Images, documentID: data.documentID, type: .Edit),
                            locationManager: locationManager,
                            journalData: journalData
                        )
                    }
                }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .onAppear{
            if data.Location.latitude != 0.0 && data.Location.longitude != 0.0 {
                locationManager.locations = Location(
                    address: data.Address,
                    label: data.Address,
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: data.Location.latitude, longitude: data.Location.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            } else {
                locationManager.requestLocation()
            }
            
            if data.ImageURL.count == 0{
                showLoading = false
            } else{
                Images = []
                JournalDataManager().FetchImage(ImageURL: data.ImageURL) { ImageList, success  in
                    DispatchQueue.main.async {
                        for (index, (_, _)) in ImageList.enumerated() {
                            Images.append(
                                ((ImageList[data.ImageURL[index]]!) as UIImage)
                            )
                        }
                        showLoading = false
                        print("\(Images)")
                    }
                }
            }
        }
    }
    
    var imageView: some View{
        HStack{
            let img: SagaImage = SagaImage(FirebaseImageURL(url: data.ImageURL[TabImageCount]), imageName: "\(TabImageCount)", folderName: String(describing: data.documentID))
            
            if img.result == .success{
                NavigationLink(destination: {
                    FullScreenImage(image: img.image!)
                }) {
                    Image(uiImage: img.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: CGFloat(screenWidth())/1.05, height: CGFloat(screenHeight())/1.75, alignment: .center)
                        .cornerRadius(15)
                        .padding()
                }
            } else if img.result == .fail{
                Text("Image couldn't be loaded.")
                    .frame(width: CGFloat(screenWidth())/1, height: CGFloat(screenHeight())/4, alignment: .center)
            } else {
                ProgressView()
                    .frame(width: CGFloat(screenWidth())/1, height: CGFloat(screenHeight())/4, alignment: .center)
            }
        }
    }
    
    var imageViewButton: some View{
        HStack{
            if TabImageCount != 0{
                Image(systemName: "arrow.left")
                    .padding()
                    .onTapGesture{
                        TabImageCount -= 1
                    }
            }
            Spacer()
            if TabImageCount != data.ImageURL.count-1{
                Image(systemName: "arrow.right")
                    .padding()
                    .onTapGesture{
                        TabImageCount += 1
                    }
            }
        }
        .frame(width: CGFloat(screenWidth())/1.05, alignment: .center)
    }
    
    var title: some View{
        Text(data.title)
            .font(.system(.headline, design: .rounded))
            .multilineTextAlignment(.leading)
            .padding()
            .frame(width: CGFloat(screenWidth()), alignment: .leading)
    }
    
    var details: some View{
        HStack{
            Image(systemName: data.Favorite ? "heart.fill" : "heart")
                .padding(.leading)
            Spacer()
            VStack{
                Text(FirebaseTimeStampToString(TimeStamp: data.TimeStamp, to: "EEEE, MMM d, yyyy - h:mm a"))
                    .font(.system(.caption2, design: .rounded))
                    .multilineTextAlignment(.trailing)
                    .padding([.horizontal, .top])
                    .frame(alignment: .trailing)
                
                Text(data.Address)
                    .font(.system(.caption2, design: .rounded))
                    .multilineTextAlignment(.trailing)
                    .padding([.horizontal, .bottom])
                    .frame(alignment: .trailing)
            }
        }
    }
    
    var entry: some View{
        Text(data.entry)
            .font(.system(.caption, design: .rounded))
            .multilineTextAlignment(.leading)
            .padding()
            .frame(width: CGFloat(screenWidth()), alignment: .leading)
    }
}
