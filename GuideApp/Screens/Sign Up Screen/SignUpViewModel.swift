import Foundation
import FirebaseCore
import FirebaseAuth
import Combine

// MARK: - вью модел экрана регистрации

class SignUpViewModel {

    @Published var successfulySignUp = false

    func signUpUser(email: String, password: String, passwordAgain: String, userName: String) {
        // разделяем имя и фамилию пользователя на 2 части
        let parts = userName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        // проверяем чтобы разделение прошло успешно а также совпадали пароли и была правильно введена почта
        if parts.count == 2 && password == passwordAgain && isValidEmail(email) {
            print("you entered your name correctly")
            let userFirstName = String(parts[0])
            let userLastName = String(parts[1])

            AuthService.shared.signUp(
                email: email,
                password: password,
                firstName: userFirstName,
                lastName: userLastName
            ) { [weak self] result in
                switch result {
                case .success:
                    self?.successfulySignUp = true
                    print("Регистрация прошла успешно!")
                case .failure(let error):
                    print("Ошибка при регистрации \(error.localizedDescription)!")
                }
            }
        } else {
            print("enter your name correctly")
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

}
