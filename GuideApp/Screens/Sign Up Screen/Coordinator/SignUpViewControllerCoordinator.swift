import UIKit

// MARK: - координатор экрана регистрации

protocol SignUpViewControllerCoordinatorOutput: AnyObject {
    func coordinatorDidSignUp()
    func coordinatorWantsToOpenLogin()
}

class SignUpViewControllerCoordinator: BaseCoodinator {
    private var navigationController: UINavigationController
    weak var output: SignUpViewControllerCoordinatorOutput?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let signUpModel = SignUpViewModel()
        let signUpVC = SignUpViewController(viewModel: signUpModel)
        signUpVC.delegate = self
        navigationController.pushViewController(signUpVC, animated: true)
    }

}
extension SignUpViewControllerCoordinator: SignUpViewControllerDelegate {
    func backToLoginScreen() {
        output?.coordinatorWantsToOpenLogin()
    }
    func signUpUser() {
        output?.coordinatorDidSignUp()
    }
}
