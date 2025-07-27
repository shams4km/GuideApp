import UIKit

// MARK: - координатор стартового экрана

protocol StartViewControllerCoordinatorOutput: AnyObject {
    func coordinatorDidLogin()
}

class StartViewControllerCoordinator: BaseCoodinator {

    private var navigationController: UINavigationController
    weak var output: StartViewControllerCoordinatorOutput?

    private var loginViewControllerCoordinator: LoginViewControllerCoordinator?
    private var signUpViewControllerCoordinator: SignUpViewControllerCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let startVC = StartViewController()
        startVC.delegate = self
        navigationController.pushViewController(startVC, animated: true)
    }

}

extension StartViewControllerCoordinator: StartViewControllerDelegate {
    func goToLoginScreen() {
        let coordinator = LoginViewControllerCoordinator(navigationController: navigationController)
        loginViewControllerCoordinator = coordinator

        coordinator.output = self
        add(coordinator: coordinator)
        coordinator.start()
    }
}

extension StartViewControllerCoordinator: LoginViewControllerCoordinatorOutput {
    func coordinatorDidLogin() {
        loginViewControllerCoordinator.map { remove(coordinator: $0) }
        output?.coordinatorDidLogin()
    }

    func coordinatorWantsToSignUp() {
        let coordinator = SignUpViewControllerCoordinator(navigationController: navigationController)
        coordinator.output = self
        signUpViewControllerCoordinator = coordinator
        add(coordinator: coordinator)
        coordinator.start()
    }
}

extension StartViewControllerCoordinator: SignUpViewControllerCoordinatorOutput {
    func coordinatorDidSignUp() {
        output?.coordinatorDidLogin()
    }

    func coordinatorWantsToOpenLogin() {
        signUpViewControllerCoordinator.map { remove(coordinator: $0) }
        navigationController.popViewController(animated: true)
    }
}
