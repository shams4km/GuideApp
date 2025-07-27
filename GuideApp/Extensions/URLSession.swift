import UIKit

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    @discardableResult
    func request(_ url: URL, handler: @escaping Handler) -> URLSessionDataTask {

        let task = dataTask(with: url, completionHandler: handler)
        task.resume()
        return task
    }
}
