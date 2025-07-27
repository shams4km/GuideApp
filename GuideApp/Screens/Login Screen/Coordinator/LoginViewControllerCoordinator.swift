import UIKit

// MARK: - координатор экрана авторизации

protocol LoginViewControllerCoordinatorOutput: AnyObject {
    func coordinatorDidLogin()
    func coordinatorWantsToSignUp()
}

class LoginViewControllerCoordinator: BaseCoodinator {
    private var navigationController: UINavigationController
    weak var output: LoginViewControllerCoordinatorOutput?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let loginModel = LoginViewModel()
        let loginVC = LoginViewController(viewModel: loginModel)
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }

}
extension LoginViewControllerCoordinator: LoginViewControllerDelegate {
    func goToSignUp() {
        output?.coordinatorWantsToSignUp()
    }
    func loginUser() {
        output?.coordinatorDidLogin()
    }

}
