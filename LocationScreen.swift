
//
//  LocationScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/19/22.
//
import SwiftUI
//import CoreLocationUI
import MapKit

private struct AnnotationTap: View{
    @StateObject var locationManager: LocationManager
    @State var place: Place?
    
    var body: some View{
        RoundedRectangle(cornerRadius: 5.0)
            .stroke(Color.Theme, lineWidth: 4.0)
            .frame(width: 30, height: 30)
            .onTapGesture {
                locationManager.locations.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: place!.latitude, longitude: place!.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)
                )
            }
    }
}

struct LocationScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var locationManager: LocationManager
    @StateObject var journalData: JournalDataManager
    @State private var showingTextField = false
    @State private var newLocation = ""
    
    @State private var showLoading: Bool = false
    
    @State private var places = [
        Place(name: "", address: "", latitude: 0.0, longitude: 0.0)
    ]
    
    var body: some View {
        ZStack {
//            ZStack{
                Map(
                    coordinateRegion: $locationManager.locations.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    annotationItems: places) { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            AnnotationTap(locationManager: locationManager, place: place)
                        }
                    }
                    .onAppear{
                        for data in journalData.JournalDataVar{
                            if data.Location.latitude != 0 && data.Location.longitude != 0 {
                                places.append(
                                    Place(name: data.Address, address: data.Address, latitude: data.Location.latitude, longitude: data.Location.longitude)
                                )
                            }
                        }
                    }
                    .navigationTitle("Location")
                    .navigationBarTitleDisplayMode(.inline)
                    .overlay{
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(Color.Theme)
                    }
//            }
            
//            if showingTextField{
//                VStack{
//                    HStack{
//                        TextField("Enter a full address", text: $newLocation)
//                            .textFieldStyle(.roundedBorder)
//                    }
//                    Button("Find address") {
//                        if newLocation.count > 5 {
//                            locationManager.FindLocationFromAddress(address: newLocation)
//                            showingTextField = false
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.Default)
//                .padding()
//            }
        }
        .animation(.easeInOut(duration: 1), value: showingTextField)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action:{
                    locationManager.requestLocation()
                }){
                    Image(systemName: "mappin.and.ellipse")
                }
            }
//
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action:{
//                    showingTextField.toggle()
//                }){
//                    Image(systemName: "magnifyingglass")
//                }
//            }
//
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action:{
                    locationManager.FindLocationFromCoordinate(coordinate: (locationManager.locations.region.center.latitude, locationManager.locations.region.center.longitude)) { result in
                        if result == .success{
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }){
                    Image(systemName: "hand.tap")
                }
            }
        }
    }
}
