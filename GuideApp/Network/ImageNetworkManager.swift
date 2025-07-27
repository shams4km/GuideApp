import UIKit
import Combine

// MARK: - класс для загрузки фото с сети и кэширования чтобы не отправлять повторный запрос

class ImageNetworkManager {
    static let shared = ImageNetworkManager()

    var cashedImages: [String: Data] = [:]

    private init() {}

    func downloadImage(by urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }

        if let data = cashedImages[urlString] {
            return UIImage(data: data)
        }

        let imageResponse = try await URLSession.shared.data(from: url)
        cashedImages[urlString] = imageResponse.0

        return UIImage(data: imageResponse.0)
    }

}
