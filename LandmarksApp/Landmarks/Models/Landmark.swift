import CoreLocation

struct Location: Codable {
    let name: String
    let category: String
    let city, state: String
    let id: Int
    let park: String
    let coordinates: Coordinates
    let imageName: String
    let isFavorite: Bool
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
}

struct Coordinates: Codable {
    let longitude, latitude: Double
}
