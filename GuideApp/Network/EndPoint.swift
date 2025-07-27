import Foundation

// MARK: - структура которая предоставляет полные URL для запроса в сеть

struct EndPoint {
    let valueForQuery: String
}
extension EndPoint {
//    в valueForQuery нужно передавать номер страницы (page number)
    var allEventsUrl: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "kudago.com"
        components.path = "/public-api/v1.2/events/"
        components.queryItems = [
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "page", value: valueForQuery),
            URLQueryItem(name: "page_size", value: "80"),
            URLQueryItem(
                name: "fields",
                value: "id,dates,title,description,body_text,location,age_restriction,price,images"
            ),
            URLQueryItem(name: "expand", value: "dates")
        ]
        guard let url = components.url else {
            print(NetworkError.invalidURL)
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
//    в valueForQuery нужно передавать строку содержащее одну или несколько id event`ов через запятую
    var allEventsByIdsUrl: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "kudago.com"
        components.path = "/public-api/v1.2/events/"
        components.queryItems = [
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(
                name: "fields",
                value: "id,dates,title,description,body_text,location,age_restriction,price,images"
            ),
            URLQueryItem(name: "expand", value: "dates"),
            URLQueryItem(name: "ids", value: valueForQuery)
        ]
        guard let url = components.url else {
            print(NetworkError.invalidURL)
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
//    в valueForQuery нужно передавать slug города (например kzn)
    var allEventsWithLocationFilter: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "kudago.com"
        components.path = "/public-api/v1.2/events/"
        components.queryItems = [
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "page_size", value: "80"),
            URLQueryItem(
                name: "fields",
                value: "id,dates,title,description,body_text,location,age_restriction,price,images"
            ),
            URLQueryItem(name: "expand", value: "dates"),
            URLQueryItem(name: "location", value: valueForQuery)
        ]
        guard let url = components.url else {
            print(NetworkError.invalidURL)
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
}
