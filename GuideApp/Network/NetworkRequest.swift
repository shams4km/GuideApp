import UIKit

class NetworkRequest {
    static let shared = NetworkRequest()
    
    private init() {}
    
    func getData(url: URL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.request(url) { data, _, error in
            DispatchQueue.main.async {
                if error != nil {
                    completionHandler(.failure(.invalidURL))
                } else {
                    guard let data else { return }
                    print("data: ", data)
                    completionHandler(.success(data))
                }
            }
            
        }
    }
    
}
