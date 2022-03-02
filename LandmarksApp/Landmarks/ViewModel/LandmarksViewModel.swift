import Foundation

final class LandmarksViewModel {
    
    var onStateChanged: ((State) -> Void)?
    var onSelectPlace: ((Location) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private var resultsArray = [Location]()
    var resultsArrayFiltered = [Location]()
    private let responseSearch: LandmarksServiceProtocol = NetworkDataFetcher()
    
    func send(_ action: Action) {
        switch action {
        case .viewIsReady:
            state = .loading
            fetchMarks()
        case let .tapCell(indexPath):
            let location = resultsArray[indexPath.row]
            onSelectPlace?(location)
        case let .switchChanged(isActiveSwitcher):
            fetchFavorites(state: isActiveSwitcher)
            state = .filterAsFavourite
        }
    }
    
    private func fetchMarks() {
        guard let url = Bundle.main.url(forResource: "landmarkData", withExtension: "json") else { fatalError("Could not find .json file") }
        responseSearch.fetchData(url: url) { [weak self] locations in
            guard let landmarksArray = locations else { return }
            self?.resultsArrayFiltered = landmarksArray
            self?.resultsArray = landmarksArray
            
            DispatchQueue.main.async {
                self?.state = .loaded
            }
        }
    }
    
    private func fetchFavorites(state: Bool) {
        if state {
            self.resultsArrayFiltered.removeAll { location in
                !location.isFavorite
            }
        } else {
            self.resultsArrayFiltered.removeAll()
            self.resultsArrayFiltered = self.resultsArray
        }
    }
}

extension LandmarksViewModel {
    
    enum Action {
        case viewIsReady
        case tapCell(IndexPath)
        case switchChanged(Bool)
    }
    
    enum State {
        case initial
        case loading
        case loaded
        case filterAsFavourite
        case error(String)
    }
}
