
//
//  JournalLocationTab.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/7/22.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var journalData: JournalDataManager
    @StateObject var locationManager: LocationManager
    
    @State private var places = [
        Place(name: "", address: "", latitude: 0.0, longitude: 0.0)
    ]
    
    @State private var showLoading: Bool = true
    
    var body: some View{
        map
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                for data in journalData.JournalDataVar{
                    if data.Location.latitude != 0 && data.Location.longitude != 0 {
                        places.append(
                            Place(name: data.Address, address: data.Address, latitude: data.Location.latitude, longitude: data.Location.longitude)
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action:{
                        locationManager.requestLocation()
                    }){
                        if locationManager.locations.label == "" {
                            ProgressView()
                        } else{
                            Image(systemName: "mappin.and.ellipse")
                            
                        }
                    }
                }
            }
    }
    
    var map: some View{
        Map(coordinateRegion: $locationManager.locations.region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: places) { place in
            MapAnnotation(coordinate: place.coordinate) {
                AnnotationTap(name: place.name, address: place.address, latitude: place.latitude, longitude: place.longitude, journalData: journalData)
            }
        }
    }
}

private struct AnnotationTap: View{
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    
    @State private var searchText = ""
    
    @StateObject var journalData: JournalDataManager
    
    var body: some View{
        NavigationLink(destination: {
            AddAnnotationButtonView
            Spacer()
        }) {
            AnnotationButton()
        }
    }
    
    var AddAnnotationButtonView: some View{
        ScrollView{
            ForEach(journalData.JournalDataVar, id: \.id){ data in
                AnnotationLogic(searchText: $searchText, data: data, latitude: latitude, longitude: longitude)
            }
            .searchable(text: $searchText, prompt: "Search By HashTag:")
            .padding(.top)
            .navigationTitle("\(name)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

private struct AnnotationLogic: View{
    @Binding var searchText: String
    
    @StateObject var locationManager = LocationManager()
    @StateObject var journalData = JournalDataManager()
    
    var data: JournalDataType
    var latitude: Double
    var longitude: Double
    
    var body: some View{
        if data.Location.latitude != 0 && data.Location.longitude != 0 {
            if data.Location.latitude == latitude && data.Location.longitude == longitude {
                if data.HashTag.description.lowercased().contains(searchText.lowercased()) || searchText.isEmpty{
                    tabNavigation
                }
            }
        }
    }
    
    var tabNavigation: some View{
        NavigationLink(destination: {
            ViewJournal(data: data, locationManager: locationManager, journalData: journalData)
        }) {
            journalListView(data: data)
        }
        .onAppear{
            if data.Location.latitude != 0.0 && data.Location.longitude != 0.0 {
                locationManager.FindLocationFromCoordinate(coordinate: (data.Location.latitude, data.Location.longitude))
            }
        }
    }
}

//struct AnnotationButton: View{
//    var body: some View{
//        RoundedRectangle(cornerRadius: 5.0)
//            .stroke(Color.Theme, lineWidth: 4.0)
//            .frame(width: 30, height: 30)
//    }
//}

struct AnnotationButton: View {
  var body: some View {
    VStack(spacing: 0) {
      Image(systemName: "mappin.circle.fill")
        .font(.title2)
        .tint(Color.ThemeAlter)
        .foregroundColor(Color.Theme)
      
      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption2)
        .tint(Color.ThemeAlter)
        .foregroundColor(Color.Theme)
        .offset(x: 0, y: -5)
    }
  }
}

