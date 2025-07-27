import Foundation
import FirebaseFirestore

// MARK: - сервис для работы с Firestore  (база данных Firebase)

class FirestoreDatabaseService {

    static let shared = FirestoreDatabaseService()

    private init() {}

    private let dataBase = Firestore.firestore()

    private var usersReference: CollectionReference {
        return dataBase.collection("users")
    }
    
    func createUser(user: UserInEvent, completion: @escaping (Result<UserInEvent, Error>) -> Void) {
        usersReference.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    func getUser(completion: @escaping (Result<UserInEvent, Error>) -> Void) {
        guard let currentUserUID = AuthService.shared.currentUser?.uid else {
            print("error in getting uid of current user")
            return
        }
        usersReference.document(currentUserUID).getDocument { documentSnapshot, error in
            guard let docSnap = documentSnapshot else { print("error in parsing user from firebase"); return }
            guard let data = docSnap.data() else { print("error in getting user dates"); return }

            if let userId = data["id"] as? String,
                let userFirstName = data["firstName"] as? String,
                let userLastName = data["lastName"] as? String,
                let userEmal = data["email"] as? String,
                let userFavoriteEventsId = data["favoriteEventsId"] as? [Int] {
                let parsedUser = UserInEvent(
                    id: userId,
                    firstName: userFirstName,
                    lastName: userLastName,
                    email: userEmal,
                    favoriteEventsId: userFavoriteEventsId
                )

                completion(.success(parsedUser))
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    func deleteUser(completion: @escaping (Error?) -> Void) {
        guard let currentUserUID = AuthService.shared.currentUser?.uid else {
            print("error in getting uid of current user")
            return
        }
        dataBase.collection("users").document(currentUserUID).delete { error in
            completion(error)
        }
    }
    func setUpdatedUserInfo(image: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUserUID = AuthService.shared.currentUser?.uid else {
            print("error in getting uid of current user")
            return
        }

        StorageService.shared.uploadUserPhoto(id: currentUserUID, image: image) { result in
            switch result {
            case .success(let sizeInfo):
                print(sizeInfo)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
