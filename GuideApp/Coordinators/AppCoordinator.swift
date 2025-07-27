import UIKit

class AppCoordinator: BaseCoodinator {

    private var window: UIWindow
    var startViewControllerCoordinator: StartViewControllerCoordinator?
    var eventsTabBarControllerCoordinator: EventsTabBarControllerCoordinator?

    private var rootNavigationController: UINavigationController?

    private var userDefaults: UserDefaults

    init(window: UIWindow, userDefaults: UserDefaults = UserDefaults.standard) {
        self.window = window
        self.userDefaults = userDefaults

        super.init()
    }

    override func start() {

        let navigationController = UINavigationController()
        rootNavigationController = navigationController

        if !childCoordinators.isEmpty {
            childCoordinators.removeAll()
        }
        if userDefaults.bool(forKey: "isLogged") == false {

            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            startViewControllerCoordinator = StartViewControllerCoordinator(navigationController: navigationController)
            startViewControllerCoordinator?.output = self
            guard let startViewControllerCoordinator else { return }
            add(coordinator: startViewControllerCoordinator)
            startViewControllerCoordinator.start()
        } else {
            let eventsTabBarController = EventsTabBarController()
            window.rootViewController = eventsTabBarController
            window.makeKeyAndVisible()

            let coordinator = EventsTabBarControllerCoordinator(eventsTabBarController: eventsTabBarController)
            coordinator.output = self
            eventsTabBarControllerCoordinator = coordinator

            add(coordinator: coordinator)
            coordinator.start()
        }
    }
}

extension AppCoordinator: EventsTabBarControllerCoordinatorOutput {
    func signOut() {

        eventsTabBarControllerCoordinator.map { remove(coordinator: $0) }
        userDefaults.removeObject(forKey: "isLogged")
        start()
    }
}

extension AppCoordinator: StartViewControllerCoordinatorOutput {
    func coordinatorDidLogin() {

        startViewControllerCoordinator.map { remove(coordinator: $0) }
        userDefaults.setValue(true, forKey: "isLogged")
        start()
    }
}
