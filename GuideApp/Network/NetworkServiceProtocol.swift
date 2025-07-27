import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func fetchAllEventsByPage(byPage: String, response: @escaping ([Event]?, NetworkError?) -> Void)
    func fetchAllEventsByIds(byIds: String, response: @escaping ([Event]?, NetworkError?) -> Void)
    func fetchAllEventsWithLocationFilter(slug: String, response: @escaping ([Event]?, NetworkError?) -> Void)
}
