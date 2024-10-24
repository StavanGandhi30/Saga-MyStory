import Foundation
import CoreLocation
import MapKit


// Address Data Model
struct Address: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let latitude, longitude: Double
    let name: String?
    let label: String
}

// Our Pin Locations
struct Location: Identifiable {
    let id = UUID()
    
    var address: String
    var label: String
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
    }
    var region: MKCoordinateRegion
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locations: Location = Location(
        address: "",
        label: "",
        region:
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
    )
    
    private let API_KEY = Bundle.main.infoDictionary?["API_KEY"] as? String
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        self.locationManager.requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        DispatchQueue.main.async {
            self.locations = Location(
                address: "",
                label: "User Location",
                region: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print (error)
    }
    
    func FindLocationFromAddress(address: String) {
        let url_string = "http://api.positionstack.com/v1/forward?access_key=\(API_KEY)&query=\(address.createURL())"
        
        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            
            if newCoordinates.data.isEmpty {
                print("Could not find address...")
                return
            }
            
            // Set the new data
            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                let address = details.name
                let label = details.label
                let latitude = details.latitude
                let longitude = details.longitude
                
                self.locations = Location(
                    address: String(describing: address),
                    label: String(describing: label),
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
        .resume()
    }
    
    
    func FindLocationFromCoordinate(coordinate: (latitude: Double, longitude: Double), completion: ((result) -> Void)? = nil){
        
        let url_string = "http://api.positionstack.com/v1/reverse?access_key=816ab591c08f8c2fb8eb8cb79c5cc492&query=\(coordinate.latitude),%20\(coordinate.longitude)"
        
        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            
            if newCoordinates.data.isEmpty {
                print("Could not find address...")
                return
            }
            
            // Set the new data
            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                
                
                self.locations = Location(
                    address: String(describing: details.name!),
                    label: String(describing: details.label),
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: details.latitude, longitude: details.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)
                    )
                )
                
                completion?(.success)
            }
        }
        .resume()
    }
    
}

enum result{
    case success, failure
}

