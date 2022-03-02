import UIKit
import CoreLocation
import MapKit

final class DetailViewModel {
    
    let location: Location
    var onStateChanged: ((DetailViewModel.State) -> Void)?
    var onSelectRegion: MKCoordinateRegion?
    
    private(set) var state: DetailViewModel.State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    init(location: Location) {
        self.location = location
    }
    
    func send(_ action: DetailViewModel.Action) {
        switch action {
        case .viewIsReady:
            setupForRegion()
        case .mapIsLoaded:
            state = .loaded
        }
    }
    
    private func setupForRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: self.location.locationCoordinate, span: span)
        self.onSelectRegion = region
        self.state = .loading
    }
}

extension DetailViewModel {
    
    enum Action {
        case viewIsReady
        case mapIsLoaded
    }
    
    enum State {
        case initial
        case loading
        case loaded
        case error(String)
    }
}
