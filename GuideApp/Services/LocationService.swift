import Foundation
import Combine

// MARK: - сервис для работы с локациями ивентов

class LocationService {

    static let shared = LocationService()

    private init() { }

    var cityMap: [String: String] = [
        "no-slug": "Reset",
        "spb": "Saint Petersburg",
        "msk": "Moscow",
        "nsk": "Novosibirsk",
        "ekb": "Ekaterinburg",
        "nnv": "Nizhniy Novgorod",
        "kzn": "Kazan",
        "vbg": "Vyborg",
        "smr": "Samara",
        "krd": "Krasnodar",
        "sochi": "Sochi",
        "ufa": "Ufa",
        "krasnoyarsk": "Krasnoyarsk",
        "kev": "Kyiv",
        "atlanta": "Atlanta",
        "london": "London",
        "newYork": "New York"
    ]
    var citySlug = [
        "no-slug",
        "spb",
        "msk",
        "nsk",
        "ekb",
        "nnv",
        "kzn",
        "vbg",
        "smr",
        "krd",
        "sochi",
        "ufa",
        "krasnoyarsk",
        "kev",
        "atlanta",
        "london",
        "newYork"
    ]

    @Published var filterTableSelectedCity: String?

    func getFullCityName(bySlug: String) -> String {
        if let fullName = cityMap[bySlug.lowercased()] {
            return fullName
        } else {
            return bySlug
        }
    }
    func getSlug(forFullCityName value: String) -> String? {
        return cityMap.first { $0.value == value }?.key
    }
}
