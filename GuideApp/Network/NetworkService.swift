import Foundation
import UIKit

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()

    private init() {}

    func fetchAllEventsByPage(byPage: String, response: @escaping ([Event]?, NetworkError?) -> Void) {
        let url = EndPoint(valueForQuery: byPage).allEventsUrl

        NetworkRequest.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let eventsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                    response(eventsResponse.results, nil)
                } catch let jsonError {
                    print("Failed to decode JSON: ", jsonError)
                }
            case .failure:
                response(nil, .decodingError)
            }
        }
    }
    func fetchAllEventsByIds(byIds: String, response: @escaping ([Event]?, NetworkError?) -> Void) {
        let url = EndPoint(valueForQuery: byIds).allEventsByIdsUrl

        NetworkRequest.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let eventsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                    response(eventsResponse.results, nil)
                } catch let jsonError {
                    print("Failed to decode JSON: ", jsonError)
                }
            case .failure:
                response(nil, .decodingError)
            }
        }
    }
    func fetchAllEventsWithLocationFilter(slug: String, response: @escaping ([Event]?, NetworkError?) -> Void) {
        let url = EndPoint(valueForQuery: slug).allEventsWithLocationFilter

        NetworkRequest.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let eventsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                    response(eventsResponse.results, nil)
                } catch let jsonError {
                    print("Failed to decode JSON: ", jsonError)
                }
            case .failure:
                response(nil, .decodingError)
            }
        }
    }

}
