import Foundation

protocol LandmarksServiceProtocol {
    func fetchData(url: URL, response: @escaping ([Location]?) -> Void)
}

class NetworkDataFetcher: LandmarksServiceProtocol {
    
    private func request(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
    
    func fetchData(url: URL, response: @escaping ([Location]?) -> Void) {
        DispatchQueue.global().async {
            self.request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var resultsArray = [Location]()
                        let landmarks = try JSONDecoder().decode([Location].self, from: data)
                        landmarks.forEach {
                            resultsArray.append($0)
                        }
                        response(resultsArray)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        response(nil)
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    response(nil)
                }
            }
        }
    }
}
