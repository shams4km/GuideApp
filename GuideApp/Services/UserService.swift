import UIKit
import Combine

// MARK: - сервис где хранится текущий пользователь с типом UserInEvent

class UserService {

    static let shared = UserService()

    private init() { }

    @Published var currentUser: UserInEvent?

    func getUserFromDatabase() {
        FirestoreDatabaseService.shared.getUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
                self?.getUserAvatarImageFromDatabase()
            case .failure(let error):
                print("error in getting user profile: ", error.localizedDescription)
            }
        }
    }
    func getUserAvatarImageFromDatabase() {
        guard var curUser = currentUser else { return }

        StorageService.shared.downloadUserPhoto(id: curUser.id) { [weak self] result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    curUser.avatarImage = image
                    self?.currentUser = curUser
                }
            case .failure(let error):
                print("error in getting user avatar image: ", error.localizedDescription)
            }

        }
    }

    func getCurrentUserFavoriteEventsId() -> [Int]? {
        return currentUser?.favoriteEventsId
    }
    func getCurrentUserFirstName() -> String? {
        return currentUser?.firstName
    }
    func getCurrentUserLastName() -> String? {
        return currentUser?.lastName
    }
    func getCurrentUserEmail() -> String? {
        return currentUser?.email
    }
    func getCurrentUser() -> UserInEvent? {
        return currentUser
    }
    func getCurrentUserImage() -> UIImage? {
        return currentUser?.avatarImage
    }
//    обновляем пользователя на удаленном сервере
    func updateUserInfo(with userInEvent: UserInEvent, completion: @escaping (Result<UserInEvent, Error>) -> Void) {
        FirestoreDatabaseService.shared.createUser(user: userInEvent) { resultDB in
            switch resultDB {
            case .success:
                completion(.success(userInEvent))
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
//    обновляем фото пользователя на удаленном сервере
    func updateUserPhoto(image: Data?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = image else { return }
        guard let currentUserUID = currentUser?.id else { print("error in getting uid of current user"); return }
        StorageService.shared.uploadUserPhoto(id: currentUserUID, image: image) { result in
            switch result {
            case .success(let sizeInfo):
                print(sizeInfo)
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
//    обновляем пользователя в UserService
    func setUpdatedUser(user: UserInEvent) {
        currentUser = user
    }

}
