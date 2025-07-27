import Foundation

enum NetworkError: String, Error {
    case invalidURL = "Invalid URL!"
    case noData = "No Data found!"
    case decodingError = "Catched decoding error!"
}
