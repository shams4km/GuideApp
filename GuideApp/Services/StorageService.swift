import Foundation
import FirebaseStorage

// MARK: - сервис для загрузки фото с FireBase хранилища

class StorageService {
    static let shared = StorageService()
    private init() {}

    private var storage = Storage.storage().reference()
    private var usersPhotoReference: StorageReference {
        storage.child("usersPhoto")
    }

    func uploadUserPhoto(id: String, image: Data, completion: @escaping (Result<String, Error>) -> Void) {

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        usersPhotoReference.child(id).putData(image, metadata: metadata) { metadata, error in

            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Size of recieved image: \(metadata.size)"))


        }
    }
    func downloadUserPhoto(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        usersPhotoReference.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }

    }
}
