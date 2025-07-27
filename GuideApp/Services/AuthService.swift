import Foundation
import Firebase

// MARK: - сервис для работы с авторизацией в Firebase (тут также хранится текущий юзер с типом User от FireBase)

class AuthService {

    static let shared = AuthService()

    private init() { }

    private let auth = Auth.auth()

    var currentUser: User? {
        return auth.currentUser
    }

    func signUp(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {

                let newUser = UserInEvent(
                    id: result.user.uid,
                    firstName: firstName,
                    lastName: lastName,
                    email: email, 
                    favoriteEventsId: []
                )

                FirestoreDatabaseService.shared.createUser(user: newUser) { resultDB in
                    switch resultDB {
                    case .success:
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            } else if let error = error {
                completion(.failure(error))
            }

        }
    }
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func signOut() {
        try? auth.signOut()
    }

}
