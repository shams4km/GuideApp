import Foundation
import Combine

// MARK: - модель вью экрана авторизации

class LoginViewModel {

    @Published var successfulyEnterLogin = false

    func signInUser(email: String, password: String) {
        AuthService.shared.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.successfulyEnterLogin = true
                print("Авторизация прошла успешно!")
            case .failure(let error):
                print("Ошибка при авторизации \(error.localizedDescription)!")
            }
        }
    }
    
}
